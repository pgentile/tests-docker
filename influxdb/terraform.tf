##### Providers #####

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

##### InfluxDB #####

resource "docker_container" "influxdb" {
  name          = "influxdb"
  image         = "${docker_image.influxdb.latest}"
  networks      = ["${docker_network.influxdb.id}"]
  network_alias = ["influxdb"]

  # HTTP API port
  ports {
    internal = 8086
    external = 8086
  }

  # Graphite support, if it is enabled
  ports {
    internal = 2003
    external = 2003
  }

  env = [
    "INFLUXDB_GRAPHITE_ENABLED=true",
  ]
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
  name     = "influxdb"
  internal = true
}

##### Chronograf #####

resource "docker_container" "chronograf" {
  name          = "chronograf"
  image         = "${docker_image.chronograf.latest}"
  networks      = [
    "${docker_network.influxdb.id}",
    "${docker_network.kapacitor.id}",
  ]
  network_alias = ["chronograf"]

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

##### Grafana #####

resource "docker_container" "grafana" {
  name          = "grafana"
  image         = "${docker_image.grafana.latest}"
  networks      = ["${docker_network.influxdb.id}"]
  network_alias = ["grafana"]

  ports {
    internal = 3000
    external = 3000
  }
}

resource "docker_image" "grafana" {
  name         = "${data.docker_registry_image.grafana.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.grafana.sha256_digest}",
  ]
}

data "docker_registry_image" "grafana" {
  name = "grafana/grafana:latest"
}

##### Kapacitor #####

resource "docker_container" "kapacitor" {
  name          = "kapacitor"
  image         = "${docker_image.kapacitor.latest}"
  networks      = [
    "${docker_network.influxdb.id}",
    "${docker_network.kapacitor.id}",
  ]
  network_alias = ["kapacitor"]

  env = [
    "KAPACITOR_INFLUXDB_0_URLS_0=http://${docker_container.influxdb.ip_address}:8086"
  ]

  ports {
    internal = 9092
    external = 9092
  }
}

resource "docker_image" "kapacitor" {
  name         = "${data.docker_registry_image.kapacitor.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.kapacitor.sha256_digest}",
  ]
}

data "docker_registry_image" "kapacitor" {
  name = "kapacitor:latest"
}

resource "docker_network" "kapacitor" {
  name     = "kapacitor"
  internal = true
}
