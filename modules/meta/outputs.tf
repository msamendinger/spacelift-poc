output "rfc1918_reserved_ip_ranges" {
  description = "IP addresses reserved for private address space"
  value       = local.rfc1918_reserved_ip_ranges
}

output "public_dns" {
  description = "DNS servers for public use, Google, Cloudflare, OpenDNS"
  value       = local.public_dns
}

