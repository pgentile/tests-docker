##### nginx #####

resource "docker_container" "nginx" {
  name  = "zucchini_nginx"
  image = "${docker_image.nginx.latest}"

  networks = [
    "${docker_network.nginx.id}",
    "${docker_network.app.id}",
  ]

  network_alias = ["nginx"]

  ports {
    internal = 80
    external = "${var.nginx_port}"
  }

  ports {
    internal = 443
    external = "${var.nginx_secure_port}"
  }

  upload {
    content = "${file("nginx/default.conf")}"
    file    = "/etc/nginx/conf.d/default.conf"
  }

  upload {
    file    = "/usr/nginx/certs/localhost.cert.pem"
    content = "${module.nginx_cert.cert_pem}"
  }

  upload {
    file    = "/usr/nginx/certs/localhost.key.pem"
    content = "${module.nginx_cert.private_key_pem}"
  }
}

module "nginx_cert" {
  source             = "./servercert"
  dns_names          = ["localhost"]
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"
  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
}

data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "nginx" {
  name         = "${data.docker_registry_image.nginx.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.nginx.sha256_digest}",
  ]
}

resource "docker_network" "nginx" {
  name     = "zucchini_nginx"
  internal = true
}

output "nginx_url" {
  description = "HAProxy URL"
  value       = "http://localhost:${var.nginx_port}"
}
