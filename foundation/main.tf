terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.9.0"
    }
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

# remote state example
# stack needs administrative permissions to use remote state
# and "workspaces" need remote state access enabled  
#
# data "terraform_remote_state" "azure-dev" {
#   backend = "remote"
#
#   config = {
#     hostname     = "spacelift.io"
#     organization = "msamendinger"
#
#     workspaces = {
#       name = "azure-dev"
#     }
#   }
# }


resource "azurerm_resource_group" "spacelift-foundation" {
  name     = "spacelift-foundation"
  location = "West Europe"
}

