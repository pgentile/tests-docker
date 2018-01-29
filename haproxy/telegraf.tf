##### Telegraf #####

resource "docker_container" "telegraf" {
  name = "zucchini-telegraf"

  image         = "${docker_image.telegraf.latest}"
  network_alias = ["telegraf"]

  networks = [
    "${docker_network.influxdb.id}",
    "${docker_network.telegraf.id}",
  ]

  upload {
    content = "${file("telegraf.conf")}"
    file    = "/etc/telegraf/telegraf.conf"
  }
}

resource "docker_image" "telegraf" {
  name         = "${data.docker_registry_image.telegraf.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.telegraf.sha256_digest}",
  ]
}

data "docker_registry_image" "telegraf" {
  name = "telegraf:latest"
}

resource "docker_network" "telegraf" {
  name     = "zucchini-telegraf"
  internal = true
}
