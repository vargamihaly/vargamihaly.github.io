variable "project" {
  description = "Short name used in resource names."
  type        = string
  default     = "mihalyvarga"

  validation {
    condition     = can(regex("^[a-z0-9]{3,20}$", var.project))
    error_message = "project must be 3-20 lowercase letters/digits."
  }
}

variable "environment" {
  description = "Environment name, e.g. prod or staging."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region. Static Web Apps is only offered in a few regions."
  type        = string
  default     = "westeurope"

  validation {
    condition     = contains(["westeurope", "westus2", "centralus", "eastus2", "eastasia"], var.location)
    error_message = "location must be a region where Azure Static Web Apps is available."
  }
}

variable "tags" {
  description = "Extra tags merged onto every resource."
  type        = map(string)
  default     = {}
}
