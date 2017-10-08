provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "haproxy" {
  name     = "zucchini-haproxy"
  image    = "pgentile/haproxy:latest"    // Can't declare a local image as a resource
  networks = ["${docker_network.app.id}"]

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 8081
    external = 8081
  }

  upload {
    content = "${file("haproxy.cfg")}"
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
  }
}

resource "docker_container" "zucchini" {
  count         = 3
  name          = "zucchini-${count.index + 1}"
  image         = "${docker_image.zucchini.latest}"
  networks      = ["${docker_network.app.id}", "${docker_network.mongo.id}"]
  network_alias = ["zucchini${count.index + 1}"]
}

resource "docker_container" "mongo" {
  name          = "zucchini-mongo"
  image         = "${docker_image.mongo.latest}"
  networks      = ["${docker_network.mongo.id}"]
  network_alias = ["mongo"]

  volumes = {
    container_path = "/data/db"
    volume_name = "${docker_volume.mongo_data.name}"
  }
}

data "docker_registry_image" "zucchini" {
  name = "pgentile/zucchini-ui:latest"
}

resource "docker_image" "zucchini" {
  name         = "${data.docker_registry_image.zucchini.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.zucchini.sha256_digest}",
  ]
}

data "docker_registry_image" "mongo" {
  name = "mongo:3"
}

resource "docker_image" "mongo" {
  name         = "${data.docker_registry_image.mongo.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.mongo.sha256_digest}",
  ]
}

resource "docker_network" "app" {
  name     = "zucchini-app"
  internal = true
}

resource "docker_network" "mongo" {
  name     = "zucchini-mongo"
  internal = true
}

resource "docker_volume" "mongo_data" {
  name = "zucchini-mongo-data"

  lifecycle {
    # Don't fuck my database
    prevent_destroy = true
  }
}
