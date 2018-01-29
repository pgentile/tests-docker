##### nginx #####

resource "docker_container" "nginx" {
  name          = "zucchini-nginx"
  image         = "${docker_image.nginx.latest}"
  network_alias = ["nginx"]

  networks = [
    "${docker_network.app.id}",
    "${docker_network.nginx.id}",
    "${docker_network.telegraf.id}",
  ]

  upload {
    content = "${file("nginx.conf")}"
    file    = "/etc/nginx/conf.d/default.conf"
  }
}

resource "docker_image" "nginx" {
  name         = "${data.docker_registry_image.nginx.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.nginx.sha256_digest}",
  ]
}

data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_network" "nginx" {
  name     = "zucchini-nginx"
  internal = true
}
