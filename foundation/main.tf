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

provider "azurerm" {
  features {}
}

provider "spacelift" {}

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

module "mazure_tags" {
  source                   = "spacelift.io/msamendinger/tags/default"
  version                  = "0.0.1"
  mbmAppName               = "spacelift infrastructure"
  mbmCloudSecResponsible   = "marc.samendinger@mercedes-benz.com"
  mbmEnvironment           = "sbx"
  mbmInformationOwner      = "marc.samendinger@mercedes-benz.com"
  mbmIso                   = "marc.samendinger@mercedes-benz.com"
  mbmPlanningItId          = "SPL-1234"
  mbmProductiveData        = "no"
  mbmTechnicalOwner        = "marc.samendinger@mercedes-benz.com"
  mbmTechnicalOwnerContact = "marc.samendinger@mercedes-benz.com"
  mbmConfidentiality       = "internal"
  mbmIntegrity             = "standard"
  mbmAvailability          = "standard"
  mbmPersonalData          = "no"
  mbmContinuityCritical    = "no"
}

resource "azurerm_resource_group" "spacelift-foundation" {
  name     = "spacelift-foundation"
  location = "West Europe"
  tags     = module.mazure_tags.tags
}

