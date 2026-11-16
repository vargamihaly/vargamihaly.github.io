# The identity GitHub Actions uses to run the site config (../) in Azure.
#
# Lives here, not in the site config, on purpose: CI must not be able to
# change its own identity or widen its own permissions. A person applies this.
#
# Login is OIDC (workload identity federation): no password/secret exists.
# GitHub issues a short-lived signed token per run; Entra ID accepts it only
# if issuer + subject + audience match a federated credential below.

data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}

locals {
  github_oidc_issuer   = "https://token.actions.githubusercontent.com"
  github_oidc_audience = "api://AzureADTokenExchange"

  # Exact "sub" claims GitHub puts in the token. Anything else is rejected:
  # other repos, forks, other environments.
  federated_subjects = {
    pull-request = "repo:${var.github_repository}:pull_request"                               # plan on PRs
    production   = "repo:${var.github_repository}:environment:${var.github_environment}"      # apply on main
    site-deploy  = "repo:${var.github_repository}:environment:${var.github_site_environment}" # upload site build
  }

  site_state_container_id = "${data.azurerm_resource_group.state.id}/providers/Microsoft.Storage/storageAccounts/sttfstatemihalyvarga/blobServices/default/containers/tfstate-site"
}

# The app's "ID card" in Entra ID.
resource "azuread_application" "ci" {
  display_name = "github-${var.project}-ci"
  owners       = [data.azuread_client_config.current.object_id]
}

# The app's account in this tenant: the thing roles are assigned to.
resource "azuread_service_principal" "ci" {
  client_id = azuread_application.ci.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# "Trust GitHub tokens for exactly these repo/event combinations."
resource "azuread_application_federated_identity_credential" "github" {
  for_each = local.federated_subjects

  application_id = azuread_application.ci.id
  display_name   = "github-${each.key}"
  description    = "GitHub Actions OIDC: ${each.value}"
  issuer         = local.github_oidc_issuer
  audiences      = [local.github_oidc_audience]
  subject        = each.value
}

# --- Permissions (least privilege) -----------------------------------------

# Manage the site's resources. Contributor (not Owner): cannot assign roles
# or change policies. Scope: this one resource group, nothing else.
resource "azurerm_role_assignment" "ci_site_contributor" {
  scope                = data.azurerm_resource_group.site.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.ci.object_id
  principal_type       = "ServicePrincipal"
}

# Read/write/lock the site state blob. Data plane only, and only the
# tfstate-site container (not the guardrails state in "tfstate").
resource "azurerm_role_assignment" "ci_site_state" {
  scope                = local.site_state_container_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.ci.object_id
  principal_type       = "ServicePrincipal"
}
