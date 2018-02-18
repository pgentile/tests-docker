output "cert_pem" {
  description = "Cert PEM"
  value       = "${tls_locally_signed_cert.cert.cert_pem}"
}

output "private_key_pem" {
  description = "Private key PEM"
  value       = "${tls_private_key.private_key.private_key_pem}"
}

output "bundle_pem" {
  description = "Bundle PEM (cert and private key)"
  value       = "${tls_private_key.private_key.private_key_pem}${tls_locally_signed_cert.cert.cert_pem}${coalesce(var.cert_chain_pem, var.ca_cert_pem)}"
}

output "cert_chain_pem" {
  description = "Certificate chain PEM"
  value       = "${tls_locally_signed_cert.cert.cert_pem}${coalesce(var.cert_chain_pem, var.ca_cert_pem)}"
}
