locals {
  whoami_count = 5
}

resource "docker_container" "whoami" {
  count = "${local.whoami_count}"
  name  = "whoami_${count.index + 1}"
  image = "${docker_image.whoami.latest}"

  network_alias = ["whoami"]

  networks = [
    "${docker_network.whoami.name}",
  ]
}

resource "docker_image" "whoami" {
  name         = "${data.docker_registry_image.whoami.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.whoami.sha256_digest}",
  ]
}

data "docker_registry_image" "whoami" {
  name = "emilevauge/whoami:latest"
}

resource "docker_network" "whoami" {
  name     = "whoami"
  internal = true
}
