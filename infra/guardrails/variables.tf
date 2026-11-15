variable "project" {
  description = "Short name used in resource names."
  type        = string
  default     = "mihalyvarga"
}

variable "monthly_budget_eur" {
  description = "Monthly budget per resource group, in the billing currency (EUR). Expected spend is ~0."
  type        = number
  default     = 1

  validation {
    condition     = var.monthly_budget_eur > 0
    error_message = "monthly_budget_eur must be greater than 0."
  }
}

variable "budget_start_date" {
  description = "First day of the month the budgets start (RFC3339). Must be the 1st of a month."
  type        = string
  default     = "2026-11-01T00:00:00Z"
}

variable "alert_emails" {
  description = <<-EOT
    Extra addresses for budget alerts. Subscription Owners are always notified.
    The repo is public: set this in a git-ignored terraform.tfvars or via
    $env:TF_VAR_alert_emails = '["you@example.com"]', never in this file.
  EOT
  type        = list(string)
  default     = []
}
