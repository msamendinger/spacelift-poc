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


data "terraform_remote_state" "azure-dev" {
  backend = "remote"

  config = {
    hostname     = "spacelift.io"
    organization = "msamendinger"

    workspaces = {
      name = "azure-de"
    }
  }
}
