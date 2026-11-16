terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # State lives in Azure Storage: see backend.tf (created by ./bootstrap).
}

provider "azurerm" {
  features {}

  # Don't try to register Azure resource providers on startup: that needs
  # subscription-level rights, and the CI identity only has rights on the
  # site's resource group. (The needed providers are already registered.)
  resource_provider_registrations = "none"

  # azurerm 4.x requires a subscription ID. It is read from the
  # ARM_SUBSCRIPTION_ID environment variable so it never lands in git.
  # Authentication comes from `az login` locally (and OIDC in CI later).
}
