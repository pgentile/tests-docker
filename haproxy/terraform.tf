##### Variables #####

variable "instance_count" {
  description = "Nombre d'instances Zucchini"
  default     = 5
}

##### Providers #####

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

##### HAProxy #####

resource "docker_container" "haproxy" {
  name = "zucchini-haproxy"

  # Can't declare a local image as a resource
  image = "pgentile/haproxy:latest"

  networks = [
    "${docker_network.app.id}",
    "${docker_network.syslogng.id}",
  ]

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 8081
    external = 8081
  }

  upload {
    content = "${data.template_file.haproxy_config.rendered}"
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
  }

  env = [
    # Send logs to syslogng
    "SYSLOGNG_ADDR=${docker_container.syslogng.ip_address}",
    # Number of Zucchini instances
    "APP_COUNT=${var.instance_count}"
  ]
}

data "template_file" "haproxy_config" {
  template = "${file("${path.module}/haproxy.cfg.tpl")}"

  vars {
    syslogng_addr = "${docker_container.syslogng.ip_address}"
    app_count = "${var.instance_count}"
  }
}

##### Syslog for HAProxy #####

resource "docker_container" "syslogng" {
  name          = "zucchini-syslogng"
  image         = "${docker_image.syslogng.latest}"
  networks      = ["${docker_network.syslogng.id}"]
  network_alias = ["syslogng"]

  command = [
    "-edv",
  ]
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
  name     = "zucchini-syslogng"
  internal = true
}

##### Zucchini #####

resource "docker_container" "zucchini" {
  count         = "${var.instance_count}"
  name          = "zucchini-${count.index + 1}"
  image         = "${docker_image.zucchini.latest}"
  networks      = ["${docker_network.app.id}", "${docker_network.mongo.id}"]
  network_alias = ["zucchini${count.index + 1}", "zucchini"]
}

resource "docker_image" "zucchini" {
  name         = "${data.docker_registry_image.zucchini.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.zucchini.sha256_digest}",
  ]
}

data "docker_registry_image" "zucchini" {
  name = "pgentile/zucchini-ui:latest"
}

resource "docker_network" "app" {
  name     = "zucchini-app"
  internal = true
}

##### Mongo #####

resource "docker_container" "mongo" {
  name          = "zucchini-mongo"
  image         = "${docker_image.mongo.latest}"
  networks      = ["${docker_network.mongo.id}"]
  network_alias = ["mongo"]

  volumes = {
    container_path = "/data/db"
    volume_name    = "${docker_volume.mongo_data.name}"
  }
}

data "docker_registry_image" "mongo" {
  name = "mongo:3"
}

resource "docker_image" "mongo" {
  name         = "${data.docker_registry_image.mongo.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.mongo.sha256_digest}",
  ]
}

resource "docker_network" "mongo" {
  name     = "zucchini-mongo"
  internal = true
}

resource "docker_volume" "mongo_data" {
  name = "zucchini-mongo-data"

  lifecycle {
    # Don't fuck my database
    prevent_destroy = true
  }
}

##### Output variables #####

output "zucchini_container_names" {
  description = "Zucchini container names"
  value       = "${docker_container.zucchini.*.name}"
}

output "zucchini_hostnames" {
  description = "Zucchini container host names"
  value       = "${sort(distinct(flatten(docker_container.zucchini.*.network_alias)))}"
}
