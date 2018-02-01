##### Mongo #####

resource "docker_container" "mongo" {
  name  = "zucchini_mongo"
  image = "${docker_image.mongo.latest}"

  networks = [
    "${docker_network.mongo.id}",
    "${docker_network.telegraf.id}",
  ]

  network_alias = ["mongo"]

  volumes = {
    container_path = "/data/db"
    volume_name    = "${docker_volume.mongo_data.name}"
  }
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

resource "docker_network" "mongo" {
  name     = "zucchini_mongo"
  internal = true
}

resource "docker_volume" "mongo_data" {
  name = "zucchini_mongo_data"

  lifecycle {
    # Don't fuck my database
    prevent_destroy = true
  }
}
