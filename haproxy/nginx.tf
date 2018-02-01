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

  upload {
    content = "${file("nginx/default.conf")}"
    file    = "/etc/nginx/conf.d/default.conf"
  }
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
