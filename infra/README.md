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

## Security scanning (Checkov)

Run `checkov` from the repo root. It reads `.checkov.yaml` and scans the Terraform code and GitHub workflows. CI runs the same scan on PRs (`.github/workflows/checkov.yml`), puts the results in **Security → Code scanning**, and fails on any finding that is neither fixed nor skipped with a reason.

Hardening applied to the state storage account: **shared keys disabled** (Entra ID only), Entra ID as the Portal default, a 1-hour SAS expiration policy.

Accepted risks (each is an inline `#checkov:skip` in `bootstrap/main.tf`):

| Check | Why accepted |
|---|---|
| CKV_AZURE_59, CKV2_AZURE_33: public endpoint, no private endpoint | GitHub-hosted runners use changing public IPs. A private endpoint costs about €7/month. |
| CKV_AZURE_206: no geo-replication | The cost guardrail allows only LRS. Versioning and soft delete cover accidental loss. |
| CKV2_AZURE_1: no customer-managed key | Needs a Key Vault, and losing the key loses all state. |
| CKV_AZURE_33: no queue logging | The queue service isn't used. |
| CKV2_AZURE_21: no blob read logging | Needs a Log Analytics workspace. Future work. |

## Roadmap

1. ✅ Resource group + Free Static Web App (local state)
2. ✅ Remote state in Azure Storage (`bootstrap/` + `backend.tf`)
3. ✅ Cost guardrails (`guardrails/`): policy deny + budgets
4. ✅ GitHub Actions (`.github/workflows/terraform.yml`): `plan` on PR (comment), `apply` on main behind the `production` environment. Logs in with OIDC using the CI identity in `guardrails/ci-identity.tf`: Contributor on the site RG, blob access to the `tfstate-site` container only.
5. `github` provider writes the deploy token to repo secrets; switch site deploy to Azure
6. Custom domain `mihaly-varga.com` (optional Azure DNS), modules, staging env
