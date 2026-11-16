variable "project" {
  description = "Short name used in resource names."
  type        = string
  default     = "mihalyvarga"
}

variable "location" {
  description = "Azure region for the state storage."
  type        = string
  default     = "westeurope"
}

variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase letters/digits). Must match ../backend.tf."
  type        = string
  default     = "sttfstatemihalyvarga"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 lowercase letters/digits."
  }
}

variable "retention_days" {
  description = "How long deleted/overwritten state blob versions can be restored."
  type        = number
  default     = 30
}
