terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  # Same state storage as the site, different blob (key).
  # Separate config on purpose: the identity that deploys the site (CI, step 4)
  # must not be able to loosen the rules that limit it. Apply this one yourself.
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mihalyvarga"
    storage_account_name = "sttfstatemihalyvarga"
    container_name       = "tfstate"
    key                  = "guardrails/prod.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
  # Subscription from ARM_SUBSCRIPTION_ID, login from `az login`.
}

# Microsoft Entra ID (identities). Tenant and login come from `az login`.
provider "azuread" {}
