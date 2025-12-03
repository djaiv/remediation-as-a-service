terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Avoid provider trying to auto register in CI or during simple demos
  # Valid values: "none", "core", "all"
  resource_provider_registrations = "none"
}
