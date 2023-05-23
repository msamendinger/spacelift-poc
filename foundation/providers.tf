
provider "azurerm" {
  features {}
  use_oidc             = true
  oidc_token_file_path = "/mnt/workspace/spacelift.oidc"

}

provider "spacelift" {}

