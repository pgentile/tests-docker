##### Chronograf #####

resource "docker_container" "chronograf" {
  name = "zucchini-chronograf"

  image         = "${docker_image.chronograf.latest}"
  network_alias = ["chronograf"]

  networks = [
    "${docker_network.influxdb.id}",
  ]

  env = [
    "INFLUXDB_URL=http://influxdb:8086",
    "INFLUXDB_USERNAME=admin",
    "INFLUXDB_PASSWORD=password",
  ]

  ports {
    internal = 8888
    external = 8888
  }
}

resource "docker_image" "chronograf" {
  name         = "${data.docker_registry_image.chronograf.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.chronograf.sha256_digest}",
  ]
}

data "docker_registry_image" "chronograf" {
  name = "chronograf:latest"
}
