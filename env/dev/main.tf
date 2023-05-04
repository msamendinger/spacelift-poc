terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "mazure_tags" {
  source                   = "spacelift.io/msamendinger/tags/default"
  version                  = "0.0.1"
  mbmAppName               = "spacelift"
  mbmCloudSecResponsible   = "marc.samendinger@mercedes-benz.com"
  mbmEnvironment           = "sbx"
  mbmInformationOwner      = "marc.samendinger@mercedes-benz.com"
  mbmIso                   = "marc.samendinger@mercedes-benz.com"
  mbmPlanningItId          = "APP-1234"
  mbmProductiveData        = "no"
  mbmTechnicalOwner        = "marc.samendinger@mercedes-benz.com"
  mbmTechnicalOwnerContact = "marc.samendinger@mercedes-benz.com"
  mbmConfidentiality       = "internal"
  mbmIntegrity             = "standard"
  mbmAvailability          = "standard"
  mbmPersonalData          = "no"
  mbmContinuityCritical    = "no"
}

resource "azurerm_resource_group" "spacelift" {
  name     = "spacelift"
  location = "West Europe"
  tags     = module.mazure_tags.tags
}

resource "azurerm_resource_group" "spacelift_sbx" {
  name     = "spacelift_sbx"
  location = "West Europe"
}

