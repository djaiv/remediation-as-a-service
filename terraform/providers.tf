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
  subscription_id                 = "c13ae4d1-e4cf-4249-bfc5-63315d2bd429"
  tenant_id                       = "a779cb4d-6784-4fb9-8c98-9389802e2960"
  resource_provider_registrations = "none"
}
