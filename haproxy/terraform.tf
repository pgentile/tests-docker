provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "whoami" {
  count    = 5
  name     = "whoami-${count.index}"
  image    = "${docker_image.whoami.latest}"
  networks = ["${docker_network.whoami.id}"]
  network_alias = ["whoami-${count.index}"]
}

resource "docker_container" "haproxy" {
  name     = "haproxy"
  image    = "pgentile/haproxy:latest"
  networks = ["${docker_network.whoami.id}"]

  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 8081
    external = 8081
  }
}

/*
resource "docker_image" "haproxy" {
  name         = "pgentile/haproxy:latest"
  keep_locally = true
}
*/

resource "docker_image" "whoami" {
  name         = "emilevauge/whoami:latest"
  keep_locally = true
}

resource "docker_network" "whoami" {
  name     = "whoami"
  internal = true
}
