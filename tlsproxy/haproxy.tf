resource "docker_image" "haproxy" {
  name         = "${data.docker_registry_image.haproxy.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.haproxy.sha256_digest}",
  ]
}

data "docker_registry_image" "haproxy" {
  name = "haproxy:latest"
}
