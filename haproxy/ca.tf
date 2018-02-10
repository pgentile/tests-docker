resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048

  # Can't serve these certificates with HaProxy
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "Zucchini Inc. CA"
    organization = "Zucchini Inc."
    locality     = "Nantes"
    country      = "FR"
  }

  validity_period_hours = "${24 * 7}"
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "ca" {
  content  = "${tls_self_signed_cert.ca.cert_pem}"
  filename = "./tls/ca.pem"
}
