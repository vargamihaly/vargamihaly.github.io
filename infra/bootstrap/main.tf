locals {
  tags = {
    project    = var.project
    purpose    = "terraform-state"
    managed-by = "terraform"
    repo       = "vargamihaly/vargamihaly.github.io"
  }
}

# Who is running Terraform right now (your `az login` user locally,
# the GitHub OIDC identity in CI). A data source READS, it never creates.
data "azurerm_client_config" "current" {}

# Separate from the site's resource group, so destroying the site
# can never touch the state that describes it.
resource "azurerm_resource_group" "state" {
  name     = "rg-tfstate-${var.project}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS" # cheapest; a few KB of state costs ~nothing

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false # no anonymous blob access, ever

  blob_properties {
    versioning_enabled = true # every state write keeps the previous version

    delete_retention_policy {
      days = var.retention_days # deleted blobs can be undeleted
    }

    container_delete_retention_policy {
      days = var.retention_days
    }
  }

  tags = local.tags

  # Losing this account = losing all state. Terraform refuses any plan
  # that would destroy it until this line is removed on purpose.
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

# Subscription Owner can manage the account (control plane) but NOT read
# blob contents (data plane). The backend uses Entra ID auth
# (use_azuread_auth = true), so whoever runs Terraform needs this role.
resource "azurerm_role_assignment" "state_blob_contributor_current" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
