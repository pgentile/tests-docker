resource "tls_locally_signed_cert" "cert" {
  ca_key_algorithm   = "${var.ca_key_algorithm}"
  ca_cert_pem        = "${var.ca_cert_pem}"
  ca_private_key_pem = "${var.ca_private_key_pem}"

  cert_request_pem = "${tls_cert_request.cert_request.cert_request_pem}"

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_cert_request" "cert_request" {
  key_algorithm   = "${var.ca_key_algorithm}"
  private_key_pem = "${tls_private_key.private_key.private_key_pem}"

  subject {
    common_name  = "${var.dns_names[0]}"
    organization = "Zucchini Inc."
    locality     = "Nantes"
    country      = "FR"
  }

  dns_names = "${var.dns_names}"
}

resource "tls_private_key" "private_key" {
  algorithm = "${var.ca_key_algorithm}"
  rsa_bits  = 2048
}
