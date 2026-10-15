terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatefastapi"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc = true
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
}
