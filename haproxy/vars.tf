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
  default     = 80
}

variable "haproxy_public_secure_port" {
  description = "HAProxy - Public secure port"
  default     = 443
}

variable "haproxy_stats_port" {
  description = "HAProxy - Stats port"
  default     = 8081
}

variable "nginx_port" {
  description = "nginx - Port"
  default     = 8090
}

variable "nginx_secure_port" {
  description = "nginx - Secure port"
  default     = 8091
}

variable "zucchini_public_port" {
  description = "Zucchini - Public port"
  default     = 9000
}

variable "zucchini_admin_port" {
  description = "Zucchini - Admin port"
  default     = 9010
}
