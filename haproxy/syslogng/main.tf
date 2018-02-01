##### Syslog for HAProxy #####

resource "docker_container" "syslogng" {
  name          = "${var.name}_syslogng"
  image         = "${docker_image.syslogng.latest}"
  networks      = ["${docker_network.syslogng.id}"]
  network_alias = ["${var.network_alias}"]

  upload {
    content = "${file("${path.module}/config/syslog-ng.conf")}"
    file    = "/etc/syslog-ng/syslog-ng.conf"
  }
}

resource "docker_image" "syslogng" {
  name         = "${data.docker_registry_image.syslogng.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.syslogng.sha256_digest}",
  ]
}

data "docker_registry_image" "syslogng" {
  name = "balabit/syslog-ng:latest"
}

resource "docker_network" "syslogng" {
  name     = "${var.name}_syslogng"
  internal = true
}
