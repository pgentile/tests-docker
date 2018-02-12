resource "docker_container" "hap_facade" {
  name = "hap_facade"

  image = "${docker_image.haproxy.latest}"

  network_alias = ["hap-facade"]

  networks = [
    "${docker_network.hap_router.name}",
  ]

  command = [
    "haproxy",
    "-f",
    "/usr/local/etc/haproxy/haproxy.cfg",
  ]

  ports {
    internal = 443
    external = 443
  }

  ports {
    internal = 8081
    external = 8081
  }

  upload {
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
    content = "${data.template_file.hap_facade_config.rendered}"
  }
}

data "template_file" "hap_facade_config" {
  template = "${file("hap-facade.cfg.tpl")}"
}
