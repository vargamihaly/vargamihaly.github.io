terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Deliberately NO backend block: this config creates the storage that the
  # main config (../) keeps its state in, so its own small state stays local
  # (bootstrap/terraform.tfstate, git-ignored).
}

provider "azurerm" {
  features {
    storage {
      # Manage the storage account only through Azure Resource Manager. The
      # data plane (queue/static-website properties) would need account keys,
      # which are disabled on the state account.
      data_plane_available = false
    }
  }

  # If the provider ever needs the storage data plane, authenticate with
  # Entra ID instead of account keys.
  storage_use_azuread = true

  # Subscription from ARM_SUBSCRIPTION_ID, login from `az login` (same as ../).
}
