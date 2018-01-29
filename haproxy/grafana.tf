##### Grafana #####

resource "docker_container" "grafana" {
  name = "zucchini-grafana"

  image         = "${docker_image.grafana.latest}"
  network_alias = ["grafana"]

  networks = [
    "${docker_network.influxdb.id}",
  ]

  # GF_PATHS_PROVISIONING will be available with future Grafana 5 release
  env = [
    "GF_DEFAULT_INSTANCE_NAME=Zucchini",
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=password",
    "GF_ALERTING_ENABLED=false",
  ]

  ports {
    internal = 3000
    external = 3000
  }

  volumes = {
    container_path = "/var/lib/grafana"
    volume_name    = "${docker_volume.grafana_data.name}"
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

resource "docker_volume" "grafana_data" {
  name = "zucchini-grafana-data"

  lifecycle {
    # Don't fuck my database
    prevent_destroy = true
  }
}
