terraform {
  required_version = ">= 1.0.0"
}

provider "spacelift" {}

terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

