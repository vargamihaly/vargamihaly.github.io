# Infrastructure (Terraform → Azure)

Hosts the site on **Azure Static Web Apps (Free plan)**.
The GitHub Pages deploy (`.github/workflows/deploy.yml`) keeps running until cutover.

## Prerequisites

- Terraform ≥ 1.9 — `winget install Hashicorp.Terraform`
- Azure CLI — `az login`

## Layout

- `bootstrap/` creates the Azure Storage that holds Terraform state. Apply it once; its own state stays local.
- `guardrails/` holds cost controls for this project's resource groups: Azure Policy deny rules and budgets. Its state is at `guardrails/prod.tfstate`. A person applies it, never CI.
- `./` (this folder) is the site itself. Its state is in Azure Storage (`backend.tf`), at blob `tfstate/site/prod.tfstate`.

## First-time setup (PowerShell)

```powershell
az login
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

cd infra/bootstrap
terraform init
terraform apply       # state storage + your blob data role

cd ..
terraform init -migrate-state   # only once, to move earlier local state
```

## Day-to-day (PowerShell)

```powershell
cd infra
az login
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

terraform init        # downloads providers, connects to the state backend
terraform fmt         # format files
terraform validate    # static checks
terraform plan        # preview: should show 2 resources to add
terraform apply       # create them (type "yes")
terraform output      # show URL etc.
```

Clean up everything: `terraform destroy`.

## Roadmap

1. ✅ Resource group + Free Static Web App (local state)
2. ✅ Remote state in Azure Storage (`bootstrap/` + `backend.tf`)
3. ✅ Cost guardrails (`guardrails/`): policy deny + budgets
4. GitHub Actions: `plan` on PR, `apply` on main, OIDC auth
5. `github` provider writes the deploy token to repo secrets; switch site deploy to Azure
6. Custom domain `mihaly-varga.com` (optional Azure DNS), modules, staging env
