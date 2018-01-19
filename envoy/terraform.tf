provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "envoy" {
  name     = "envoy"
  image    = "pgentile/envoy:latest"         // Can't declare a local image as a resource
  networks = ["${docker_network.jaeger.id}"]

  command = [
    "--log-level",
    "debug",
    "--service-cluster",
    "envoy",
  ]

  ports {
    internal = 10000
    external = 10000
  }

  ports {
    internal = 9901
    external = 9901
  }

  upload {
    content = "${file("config.yaml")}"
    file    = "/tmp/config.yaml"
  }
}

data "docker_registry_image" "jaeger" {
  name = "jaegertracing/all-in-one:latest"
}

resource "docker_image" "jaeger" {
  name         = "${data.docker_registry_image.jaeger.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.jaeger.sha256_digest}",
  ]
}

resource "docker_container" "jaeger" {
  name     = "jaeger"
  image    = "${docker_image.jaeger.latest}"
  networks = ["${docker_network.jaeger.id}"]

  env = [
    "COLLECTOR_ZIPKIN_HTTP_PORT=9411",
  ]

  ports {
    internal = 16686
    external = 16686
  }
}

resource "docker_network" "jaeger" {
  name     = "jaeger"
  internal = true
}
