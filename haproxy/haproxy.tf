##### HAProxy #####

resource "docker_container" "haproxy" {
  name = "zucchini_haproxy"

  # Can't declare a local image as a resource
  image = "pgentile/haproxy:latest"

  network_alias = ["haproxy"]

  networks = [
    "${docker_network.app.id}",
    "${module.syslogng_haproxy.network_id}",
    "${docker_network.telegraf.id}",
  ]

  ports {
    internal = 8080
    external = "${var.haproxy_public_port}"
  }

  ports {
    internal = 8081
    external = "${var.haproxy_stats_port}"
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

output "haproxy_url" {
  description = "HAProxy URL"
  value       = "http://localhost:${var.haproxy_public_port}"
}

output "haproxy_stats_url" {
  description = "HAProxy Stats URL"
  value       = "http://localhost:${var.haproxy_stats_port}"
}
