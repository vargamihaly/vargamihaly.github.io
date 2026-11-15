terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Step 1 uses local state (terraform.tfstate in this folder, git-ignored).
  # Step 2 will move it to an Azure Storage backend.
}

provider "azurerm" {
  features {}

  # azurerm 4.x requires a subscription ID. It is read from the
  # ARM_SUBSCRIPTION_ID environment variable so it never lands in git.
  # Authentication comes from `az login` locally (and OIDC in CI later).
}
