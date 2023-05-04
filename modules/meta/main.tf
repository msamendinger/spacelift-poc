locals {
  rfc1918_reserved_ip_ranges = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  public_dns = [
    "1.1.1.1",
    "8.8.8.8",
    "208.67.222.123",
    "208.67.220.123"
  ]
}

