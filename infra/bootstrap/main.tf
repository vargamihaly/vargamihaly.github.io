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
  # Checkov findings accepted on purpose (risk decisions, see infra/README.md):
  #checkov:skip=CKV_AZURE_59:Public endpoint needed: GitHub-hosted runners use changing public IPs. Access requires Entra ID + RBAC; shared keys are disabled.
  #checkov:skip=CKV2_AZURE_33:Private endpoint costs ~7 EUR/month and GitHub-hosted runners could not reach it.
  #checkov:skip=CKV_AZURE_206:Cost guardrail allows Standard_LRS only. Versioning + soft delete cover accidental loss; a regional outage is acceptable here.
  #checkov:skip=CKV2_AZURE_1:Customer-managed key needs a Key Vault and losing the key loses all state. Microsoft-managed AES-256 encryption is sufficient.
  #checkov:skip=CKV_AZURE_33:Queue service is not used.
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS" # cheapest; a few KB of state costs ~nothing

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false # no anonymous blob access, ever

  # Entra ID only: no account keys and no key-based SAS. Without this, anyone
  # who can call listKeys gets full data access and bypasses RBAC. (CKV2_AZURE_40)
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true # Azure Portal also uses Entra ID

  # Defense in depth: SAS tokens should be short-lived. (CKV2_AZURE_41)
  sas_policy {
    expiration_period = "00.01:00:00" # 1 hour
    expiration_action = "Log"
  }

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

# State of configs that only a person applies (guardrails).
resource "azurerm_storage_container" "tfstate" {
  #checkov:skip=CKV2_AZURE_21:Read logging needs a Log Analytics workspace (new resource type + cost). Planned as future work.
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

# State of the site config. The CI identity gets blob access to THIS
# container only (Azure RBAC can't be scoped below a container), so it
# can never touch the guardrails state in "tfstate".
resource "azurerm_storage_container" "tfstate_site" {
  #checkov:skip=CKV2_AZURE_21:Read logging needs a Log Analytics workspace (new resource type + cost). Planned as future work.
  name                  = "tfstate-site"
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
