output "policy_assignments" {
  description = "Deny guardrails per resource group."
  value = merge(
    { for k, a in azurerm_resource_group_policy_assignment.allowed_types : "allowed-types/${k}" => a.id },
    {
      "swa-free-only/site"     = azurerm_resource_group_policy_assignment.swa_free_only.id
      "storage-lrs-only/state" = azurerm_resource_group_policy_assignment.storage_lrs_only.id
    },
  )
}

output "github_actions_variables" {
  description = "Set these as GitHub repository variables (Settings > Secrets and variables > Actions > Variables). Not secrets: they are identifiers."
  value = {
    AZURE_CLIENT_ID       = azuread_application.ci.client_id
    AZURE_TENANT_ID       = data.azuread_client_config.current.tenant_id
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
  }
}

output "budgets" {
  description = "Monthly budgets (EUR) per resource group."
  value       = { for k, b in azurerm_consumption_budget_resource_group.this : k => "${b.name}: ${b.amount}" }
}
