variable "name" {
  description = "Name of the intermediate certificate"
  type        = "string"
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
