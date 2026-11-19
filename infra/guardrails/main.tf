# Cost guardrails for this project's resource groups ONLY.
# The subscription also hosts other projects, so nothing here is assigned at
# subscription scope (that would block their deployments).
#
# Pay-As-You-Go subscriptions have no hard spending cap, so cost is controlled by:
#   1. PREVENTION  - Azure Policy denies anything that could cost money
#                    (other resource types, paid SKUs) at create/update time.
#   2. DETECTION   - budgets e-mail you if anything costs money anyway.

# These resource groups are owned by other configs (../ and ../bootstrap).
# Data sources READ them; this config never creates or deletes them.
data "azurerm_resource_group" "site" {
  name = "rg-${var.project}-prod"
}

data "azurerm_resource_group" "state" {
  name = "rg-tfstate-${var.project}"
}

locals {
  protected = {
    site = {
      id            = data.azurerm_resource_group.site.id
      allowed_types = ["Microsoft.Web/staticSites"]
    }
    state = {
      id            = data.azurerm_resource_group.state.id
      allowed_types = ["Microsoft.Storage/storageAccounts"]
    }
  }

  # Built-in policy definitions (same IDs in every Azure tenant).
  builtin = {
    allowed_resource_types = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"
    allowed_storage_skus   = "/providers/Microsoft.Authorization/policyDefinitions/7433c107-6db4-4ad1-b57a-a76dce0154a1"
  }
}

# ---------------------------------------------------------------------------
# 1. PREVENTION (Azure Policy, effect = Deny)
# ---------------------------------------------------------------------------

# Only the resource types each group needs. Anything else (VMs, SQL, App
# Service plans, ...) is rejected by Azure with RequestDisallowedByPolicy.
resource "azurerm_resource_group_policy_assignment" "allowed_types" {
  for_each = local.protected

  name                 = "allowed-resource-types"
  display_name         = "Cost guardrail: allowed resource types (${each.key})"
  resource_group_id    = each.value.id
  policy_definition_id = local.builtin.allowed_resource_types

  parameters = jsonencode({
    listOfResourceTypesAllowed = { value = each.value.allowed_types }
    effect                     = { value = "Deny" }
  })

  non_compliance_message {
    content = "Cost guardrail: only ${join(", ", each.value.allowed_types)} may be created in this resource group (see infra/guardrails)."
  }
}

# No built-in policy covers Static Web App SKUs, so this one is custom:
# deny any Static Web App whose SKU is not Free (Standard costs ~9 USD/month).
resource "azurerm_policy_definition" "swa_free_only" {
  name         = "swa-free-sku-only"
  display_name = "Static Web Apps must use the Free SKU"
  description  = "Cost guardrail: denies Static Web Apps on any paid SKU."
  policy_type  = "Custom"
  mode         = "Indexed"

  metadata = jsonencode({ category = "Cost" })

  # "if"/"then" are quoted: Terraform accepts them bare, but Checkov's HCL
  # parser treats them as keywords and would silently skip this whole file.
  policy_rule = jsonencode({
    "if" = {
      allOf = [
        { field = "type", equals = "Microsoft.Web/staticSites" },
        { field = "Microsoft.Web/staticSites/sku.name", notEquals = "Free" },
      ]
    }
    "then" = { effect = "deny" }
  })
}

resource "azurerm_resource_group_policy_assignment" "swa_free_only" {
  name                 = "swa-free-sku-only"
  display_name         = "Cost guardrail: Static Web Apps must be Free (site)"
  resource_group_id    = local.protected.site.id
  policy_definition_id = azurerm_policy_definition.swa_free_only.id

  non_compliance_message {
    content = "Cost guardrail: Static Web Apps in this resource group must use the Free SKU."
  }
}

# The state storage account may only use the cheapest redundancy.
resource "azurerm_resource_group_policy_assignment" "storage_lrs_only" {
  name                 = "storage-standard-lrs-only"
  display_name         = "Cost guardrail: storage must be Standard_LRS (state)"
  resource_group_id    = local.protected.state.id
  policy_definition_id = local.builtin.allowed_storage_skus

  parameters = jsonencode({
    listOfAllowedSKUs = { value = ["Standard_LRS"] }
    effect            = { value = "Deny" }
  })

  non_compliance_message {
    content = "Cost guardrail: storage accounts in this resource group must be Standard_LRS."
  }
}

# ---------------------------------------------------------------------------
# 2. DETECTION (budgets: they only notify, they never stop anything)
# ---------------------------------------------------------------------------

resource "azurerm_consumption_budget_resource_group" "this" {
  for_each = local.protected

  name              = "budget-${each.key}-monthly"
  resource_group_id = each.value.id
  amount            = var.monthly_budget_eur
  time_grain        = "Monthly"

  time_period {
    start_date = var.budget_start_date
  }

  # Any real spend is unexpected here, so the first alert fires early.
  notification {
    enabled        = true
    operator       = "GreaterThanOrEqualTo"
    threshold      = 10
    threshold_type = "Actual"
    contact_roles  = ["Owner"]
    contact_emails = var.alert_emails
  }

  notification {
    enabled        = true
    operator       = "GreaterThanOrEqualTo"
    threshold      = 100
    threshold_type = "Actual"
    contact_roles  = ["Owner"]
    contact_emails = var.alert_emails
  }

  notification {
    enabled        = true
    operator       = "GreaterThanOrEqualTo"
    threshold      = 100
    threshold_type = "Forecasted"
    contact_roles  = ["Owner"]
    contact_emails = var.alert_emails
  }
}
