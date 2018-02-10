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
    internal = 8080
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
    file    = "/usr/local/etc/haproxy/cert.pem"
    content = "${tls_locally_signed_cert.haproxy.cert_pem}${tls_private_key.haproxy.private_key_pem}"
  }
}

data "template_file" "haproxy_config" {
  template = "${file("haproxy/haproxy.cfg.tpl")}"

  vars {
    app_count = "${var.instance_count}"
  }
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "Zucchini Inc. CA"
    organization = "Zucchini Inc."
    locality     = "Nantes"
    country      = "FR"
  }

  validity_period_hours = "${24 * 7}"
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_cert_request" "haproxy" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.haproxy.private_key_pem}"

  subject {
    common_name  = "localhost"
    organization = "Zucchini Inc."
    locality     = "Nantes"
    country      = "FR"
  }

  dns_names = ["localhost"]
}

resource "tls_private_key" "haproxy" {
  algorithm = "RSA"
  rsa_bits  = 2048

  # Can't serve these certificates with HaProxy
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
}

resource "local_file" "haproxy" {
  content  = "${tls_locally_signed_cert.haproxy.cert_pem}"
  filename = "./tls/haproxy.pem"
}

/*
resource "local_file" "haproxy_key" {
    content     = "${tls_private_key.haproxy_key.private_key_pem}"
    filename = "./tls/key.pem"
}
*/

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
