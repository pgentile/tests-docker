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
  template = "${file("haproxy/haproxy.cfg.tpl")}"

  vars {
    app_count = "${var.instance_count}"
  }
}
