##### InfluxDB #####

resource "docker_container" "influxdb" {
  name = "zucchini-influxdb"

  image         = "${docker_image.influxdb.latest}"
  network_alias = ["influxdb"]

  networks = [
    "${docker_network.influxdb.id}",
  ]

  env = [
    "INFLUXDB_DB=zucchini",
    "INFLUXDB_HTTP_AUTH_ENABLED=true",
    "INFLUXDB_ADMIN_USER=admin",
    "INFLUXDB_ADMIN_PASSWORD=password",
    "INFLUXDB_USER=zucchini",
    "INFLUXDB_USER_PASSWORD=password",
  ]

  ports {
    internal = 8086
    external = 8086
  }
}

resource "docker_image" "influxdb" {
  name         = "${data.docker_registry_image.influxdb.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.influxdb.sha256_digest}",
  ]
}

data "docker_registry_image" "influxdb" {
  name = "influxdb:latest"
}

resource "docker_network" "influxdb" {
  name     = "zucchini-influxdb"
  internal = true
}
