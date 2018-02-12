variable "dns_names" {
  description = "DNS names of the server. First name will be the certificate common name"
  type        = "list"
}

variable "ca_key_algorithm" {
  description = "CA certificate algorithm"
  type        = "string"
}

variable "ca_cert_pem" {
  description = "CA cert PEM"
  type        = "string"
}

variable "ca_private_key_pem" {
  description = "CA private key PEM"
  type        = "string"
}
