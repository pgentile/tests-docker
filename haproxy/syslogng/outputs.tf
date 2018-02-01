output "network_id" {
  description = "Network ID"
  value       = "${docker_network.syslogng.id}"
}
