##### Variables #####

variable "instance_count" {
  description = "Nombre d'instances Zucchini"
  default     = 3
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

  network_alias = ["haproxy"]

  networks = [
    "${docker_network.app.id}",
    "${docker_network.nginx.id}",
    "${docker_network.syslogng.id}",
    "${docker_network.telegraf.id}",
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
}

data "template_file" "haproxy_config" {
  template = "${file("${path.module}/haproxy.cfg.tpl")}"

  vars {
    app_count = "${var.instance_count}"
  }
}

##### nginx #####

resource "docker_container" "nginx" {
  name = "zucchini-nginx"
  image         = "${docker_image.nginx.latest}"
  network_alias = ["nginx"]

  networks = [
    "${docker_network.app.id}",
    "${docker_network.nginx.id}",
    "${docker_network.telegraf.id}",
  ]

  upload {
    content = "${file("nginx.conf")}"
    file    = "/etc/nginx/conf.d/default.conf"
  }
}

resource "docker_image" "nginx" {
  name         = "${data.docker_registry_image.nginx.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.nginx.sha256_digest}",
  ]
}

data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_network" "nginx" {
  name     = "zucchini-nginx"
  internal = true
}


##### Syslog for HAProxy #####

resource "docker_container" "syslogng" {
  name          = "zucchini-syslogng"
  image         = "${docker_image.syslogng.latest}"
  networks      = ["${docker_network.syslogng.id}"]
  network_alias = ["syslogng"]

  upload {
    content = "${file("syslog-ng.conf")}"
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
  name     = "zucchini-syslogng"
  internal = true
}

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
    ### "GF_DATABASE_PATH=/data/db/grafana.db",
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



##### Chronograf #####


resource "docker_container" "chronograf" {
  name = "zucchini-chronograf"

  image         = "${docker_image.chronograf.latest}"
  network_alias = ["chronograf"]

  networks = [
    "${docker_network.influxdb.id}",
  ]

  env = [
    "INFLUXDB_URL=http://influxdb:8086",
    "INFLUXDB_USERNAME=admin",
    "INFLUXDB_PASSWORD=password"
  ]

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


##### Telegraf #####


resource "docker_container" "telegraf" {
  name = "zucchini-telegraf"

  image         = "${docker_image.telegraf.latest}"
  network_alias = ["telegraf"]

  networks = [
    "${docker_network.influxdb.id}",
    "${docker_network.telegraf.id}",
  ]

  upload {
    content = "${file("telegraf.conf")}"
    file    = "/etc/telegraf/telegraf.conf"
  }

}

resource "docker_image" "telegraf" {
  name         = "${data.docker_registry_image.telegraf.name}"
  keep_locally = true

  pull_triggers = [
    "${data.docker_registry_image.telegraf.sha256_digest}",
  ]
}

data "docker_registry_image" "telegraf" {
  name = "telegraf:latest"
}

resource "docker_network" "telegraf" {
  name     = "zucchini-telegraf"
  internal = true
}



##### Zucchini #####

resource "docker_container" "zucchini" {
  count         = "${var.instance_count}"
  name          = "zucchini-${count.index + 1}"
  image         = "${docker_image.zucchini.latest}"
  networks      = ["${docker_network.app.id}", "${docker_network.mongo.id}"]
  network_alias = ["zucchini${count.index + 1}", "zucchini"]

  env = [
    # Other JVM flags: -XX:+PrintCommandLineFlags -XX:+PrintFlagsFinal -XX:+PrintFlagsInitial
    "JAVA_OPTS=-showversion -verbose:gc -Xms512m -Xmx512m -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintCommandLineFlags",
  ]
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
  networks      = [
    "${docker_network.mongo.id}",
    "${docker_network.telegraf.id}",
  ]
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
