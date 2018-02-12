resource "docker_container" "hap_router_0" {
  name  = "hap_router_0"

  image = "${docker_image.haproxy.latest}"

  network_alias = ["hap-router"]

  networks = [
    "${docker_network.whoami.name}",
    "${docker_network.hap_router.name}",
  ]

  command = [
    "haproxy",
    "-f",
    "/usr/local/etc/haproxy/haproxy.cfg",
  ]

  ports {
    internal = 8081
    external = "${8081 + 1}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
    content = "${data.template_file.hap_router_config.rendered}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/certs/localhost.pem"
    content = "${module.hap_router_cert_0.bundle_pem}"
  }
}

resource "docker_container" "hap_router_1" {
  name  = "hap_router_1"

  image = "${docker_image.haproxy.latest}"

  network_alias = ["hap-router"]

  networks = [
    "${docker_network.whoami.name}",
    "${docker_network.hap_router.name}",
  ]

  command = [
    "haproxy",
    "-f",
    "/usr/local/etc/haproxy/haproxy.cfg",
  ]

  ports {
    internal = 8081
    external = "${8081 + 2}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
    content = "${data.template_file.hap_router_config.rendered}"
  }

  upload {
    file    = "/usr/local/etc/haproxy/certs/localhost.pem"
    content = "${module.hap_router_cert_1.bundle_pem}"
  }
}

data "template_file" "hap_router_config" {
  template = "${file("hap-router.cfg.tpl")}"

  vars {
    whoami_count = "${local.whoami_count}"
  }
}

module "hap_router_cert_0" {
  source             = "./servercert"
  dns_names          = ["localhost"]
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"
  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
}

module "hap_router_cert_1" {
  source             = "./servercert"
  dns_names          = ["localhost"]
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"
  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
}

resource "docker_network" "hap_router" {
  name     = "hap_router"
  internal = true
}
