resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Validate that the entered Azure AD login actually exists.
# This uses a local + validation block to give a clear error
# before even attempting resource creation.

locals {
  # Object ID is auto-fetched from Azure AD — no manual input needed
  sql_admin_object_id = data.azuread_user.sql_admin.object_id

  # Display useful info for confirmation
  sql_admin_display_name = data.azuread_user.sql_admin.display_name
  sql_admin_upn          = data.azuread_user.sql_admin.user_principal_name
  sql_admin_account_enabled = data.azuread_user.sql_admin.account_enabled
}

# Guard: Fail if the found account is DISABLED
resource "null_resource" "validate_admin_account" {
  lifecycle {
    precondition {
      condition     = local.sql_admin_account_enabled == true
      error_message = "ERROR: The Azure AD account '${var.sql_azuread_login}' exists but is DISABLED. Please provide an active account."
    }
  }
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_local_admin_username
  administrator_login_password = var.sql_local_admin_password

  azuread_administrator {
    login_username = local.sql_admin_upn         # Normalized UPN from Azure AD
    object_id      = local.sql_admin_object_id   # Auto-fetched — no manual input
  }

  public_network_access_enabled        = false
  minimum_tls_version                  = "1.2"
  outbound_network_restriction_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = var.resource_tags

  depends_on = [null_resource.validate_admin_account]
}

resource "azurerm_mssql_database" "sqldb" {
  name        = var.sql_db_name
  server_id   = azurerm_mssql_server.sqlserver.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "GP_S_Gen5_1"
  max_size_gb = 1

  zone_redundant              = false
  min_capacity                = var.compute_tier == "serverless" ? 0.5 : null
  auto_pause_delay_in_minutes = var.compute_tier == "serverless" ? 60 : null

  tags = var.resource_tags

  short_term_retention_policy {
    retention_days           = var.pitr_retention_days
    backup_interval_in_hours = var.pitr_diff_backup_interval_in_hours
  }
# serverless tier doesn't support long term retention policy
  dynamic "long_term_retention_policy" {
    for_each = var.compute_tier != "serverless" ? [1] : []
    content {
      weekly_retention  = var.ltr_weekly_retention
      monthly_retention = var.ltr_monthly_retention
      yearly_retention  = var.ltr_yearly_retention
      week_of_year      = var.ltr_week_of_year
    }
  }
}