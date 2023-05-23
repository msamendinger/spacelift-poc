output "worker_pool_private_key" {
  value = tls_private_key.workers.private_key_pem
}

