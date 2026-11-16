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
  features {}
  # Subscription from ARM_SUBSCRIPTION_ID, login from `az login` (same as ../).
}
