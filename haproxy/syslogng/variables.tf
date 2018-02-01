variable "name" {
  description = "Name used in container name and network"
}

variable "network_alias" {
  description = "Container alias in the network"
  default     = "syslogng"
}
