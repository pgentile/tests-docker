##### Variables #####

variable "instance_count" {
  description = "Nombre d'instances Zucchini"
  default     = 3
}

variable "grafana_port" {
  description = "Grafana - Port"
  default     = 3000
}

variable "haproxy_public_port" {
  description = "HAProxy - Public port"
  default     = 8080
}

variable "haproxy_stats_port" {
  description = "HAProxy - Stats port"
  default     = 8081
}
