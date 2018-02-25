##### HAProxy #####

resource "docker_container" "haproxy" {
  name = "zucchini_haproxy"

  # Can't declare a local image as a resource
  image = "pgentile/haproxy:latest"

  network_alias = ["haproxy"]

  networks = [
    "${docker_network.app.id}",
    "${module.syslogng_haproxy.network_id}",
    "${docker_network.telegraf.id}",
  ]

  ports {
    internal = 80
    external = "${var.haproxy_public_port}"
  }

  ports {
    internal = 443
    external = "${var.haproxy_public_secure_port}"
  }

  ports {
    internal = 8081
    external = "${var.haproxy_stats_port}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
    content = "${data.template_file.haproxy_config.rendered}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/certs/localhost.pem"
    content = "${module.haproxy_cert.bundle_pem}"
  }
}

data "template_file" "haproxy_config" {
  template = "${file("haproxy/haproxy.cfg.tpl")}"

  vars {
    app_count = "${var.instance_count}"
  }
}

module "haproxy_cert" {
  source             = "./servercert"
  dns_names          = ["localhost"]
  ca_cert_pem        = "${module.haproxy_intermediate_cert.cert_pem}"
  ca_key_algorithm   = "${module.haproxy_intermediate_cert.algorithm}"
  ca_private_key_pem = "${module.haproxy_intermediate_cert.private_key_pem}"
  cert_chain_pem     = "${module.haproxy_intermediate_cert.cert_chain_pem}"
}

module "haproxy_intermediate_cert" {
  source             = "./intermediatecert"
  name               = "Zucchini intermediate authority"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"
  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
}

resource "local_file" "haproxy" {
  content  = "${module.haproxy_cert.cert_chain_pem}"
  filename = "./tls/haproxy.pem"
}

output "haproxy_url" {
  description = "HAProxy URL"
  value       = "http://localhost:${var.haproxy_public_port}"
}

output "haproxy_secure_url" {
  description = "HAProxy secure URL"
  value       = "https://localhost:${var.haproxy_public_secure_port}"
}

output "haproxy_stats_url" {
  description = "HAProxy Stats URL"
  value       = "http://localhost:${var.haproxy_stats_port}"
}
