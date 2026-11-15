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

  # azurerm 4.x requires a subscription ID. It is read from the
  # ARM_SUBSCRIPTION_ID environment variable so it never lands in git.
  # Authentication comes from `az login` locally (and OIDC in CI later).
}
