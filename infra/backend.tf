# Remote state in Azure Storage (created by ./bootstrap).
# Backend blocks are read before anything else, so no variables allowed here.
# After adding/changing this block run: terraform init -migrate-state
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-mihalyvarga"
    storage_account_name = "sttfstatemihalyvarga"
    container_name       = "tfstate-site" # the only container CI can access
    key                  = "prod.tfstate" # blob path; one key per environment
    use_azuread_auth     = true           # Entra ID (az login / OIDC), not storage keys
  }
}
