# Infrastructure (Terraform → Azure)

Hosts the site on **Azure Static Web Apps (Free plan)**.
The GitHub Pages deploy (`.github/workflows/deploy.yml`) keeps running until cutover.

## Prerequisites

- Terraform ≥ 1.9 — `winget install Hashicorp.Terraform`
- Azure CLI — `az login`

## Run (PowerShell)

```powershell
cd infra
az login
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

terraform init        # downloads the azurerm provider, creates .terraform.lock.hcl
terraform fmt         # format files
terraform validate    # static checks
terraform plan        # preview: should show 2 resources to add
terraform apply       # create them (type "yes")
terraform output      # show URL etc.
```

Clean up everything: `terraform destroy`.

## Roadmap

1. ✅ Resource group + Free Static Web App (local state)
2. Remote state in Azure Storage
3. Budget alert
4. GitHub Actions: `plan` on PR, `apply` on main, OIDC auth
5. `github` provider writes the deploy token to repo secrets; switch site deploy to Azure
6. Custom domain `mihaly-varga.com` (optional Azure DNS), modules, staging env
