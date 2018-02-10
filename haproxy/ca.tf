resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048

  # Can't serve these certificates with HaProxy
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
}

resource "tls_locally_signed_cert" "haproxy" {
  cert_request_pem = "${tls_cert_request.haproxy.cert_request_pem}"

  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"
  ca_key_algorithm   = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"

  validity_period_hours = 24

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
