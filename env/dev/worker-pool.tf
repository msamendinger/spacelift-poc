resource "tls_private_key" "workers" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "workers" {
  private_key_pem = tls_private_key.workers.private_key_pem

  subject {
    common_name  = azurerm_public_ip.spacelift-worker.fqdn
    organization = "MBM"
  }
}

resource "spacelift_worker_pool" "mbm" {
  name        = "Main worker"
  csr         = tls_cert_request.workers.cert_request_pem
  description = "Used for all type jobs"
}
