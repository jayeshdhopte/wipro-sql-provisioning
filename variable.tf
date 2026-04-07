variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Location for SQL deployment"
  type        = string
}

variable "sql_server_name" {
  description = "SQL Server Name"
  type        = string
}

variable "sql_db_name" {
  description = "SQL Database Name"
  type        = string
}

# This is the ONLY input needed from ServiceNow.
# Object ID is NO LONGER a variable — it's auto-fetched.
# Validation ensures only valid UPN formats are accepted.

variable "sql_azuread_login" {
  description = "Azure AD user (internal or guest user)"
  type        = string

  validation {
    condition = (
      can(regex("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$", var.sql_azuread_login))
      ||
      can(regex("^[a-zA-Z0-9._%+\\-]+#EXT#@[a-zA-Z0-9.\\-]+\\.onmicrosoft\\.com$", var.sql_azuread_login))
    )

    error_message = "ERROR: '${var.sql_azuread_login}' must be either a valid internal user (user@domain.com) or a valid guest user (#EXT# format)."
  }
}

variable "sql_local_admin_username" {
  description = "Local SQL admin username (avoid hardcoding — pass via pipeline secret)"
  type        = string
  sensitive   = true
}

variable "sql_local_admin_password" {
  description = "Local SQL admin password (avoid hardcoding — pass via pipeline secret)"
  type        = string
  sensitive   = true
}

variable "resource_tags" {
  description = "Resource Tags"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "default"
  }
}

variable "sku_tier" {
  description = "SQL SKU Tier"
  type        = string
}

variable "compute_tier" {
  description = "Compute Tier"
  type        = string
}

variable "pitr_diff_backup_interval_in_hours" {
  description = "Differential backup interval"
  type        = number
}

variable "pitr_retention_days" {
  description = "Short-term retention days"
  type        = number
}

variable "ltr_monthly_retention" {
  type = string
}

variable "ltr_weekly_retention" {
  type = string
}

variable "ltr_week_of_year" {
  type = number
}

variable "ltr_yearly_retention" {
  type = string
}