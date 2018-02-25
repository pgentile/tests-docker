##### Grafana #####

locals {
  grafana_version = "5.0.0-beta4"
}

resource "docker_container" "grafana" {
  name = "zucchini_grafana"

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
    "GF_ALERTING_ENABLED=true",
  ]

  ports {
    external = "${var.grafana_port}"
    internal = 3000
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
  name = "grafana/grafana:${local.grafana_version}"
}

resource "docker_volume" "grafana_data" {
  name = "zucchini_grafana_data"

  lifecycle {
    # Don't fuck my database
    prevent_destroy = true
  }
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://localhost:${var.grafana_port}"
}
