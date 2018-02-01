##### Zucchini #####

resource "docker_container" "zucchini" {
  count         = "${var.instance_count}"
  name          = "zucchini_${count.index + 1}"
  image         = "${docker_image.zucchini.latest}"
  networks      = ["${docker_network.app.id}", "${docker_network.mongo.id}"]
  network_alias = ["zucchini${count.index + 1}", "zucchini"]

  env = [
    # Other JVM flags: -XX:+PrintCommandLineFlags -XX:+PrintFlagsFinal -XX:+PrintFlagsInitial
    "JAVA_OPTS=-showversion -verbose:gc -Xms512m -Xmx512m -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintCommandLineFlags",
  ]

  ports {
    external = "${var.zucchini_public_port + count.index}"
    internal = 8080
  }

  ports {
    external = "${var.zucchini_admin_port + count.index}"
    internal = 8081
  }
  
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
  name     = "zucchini_app"
  internal = true
}
