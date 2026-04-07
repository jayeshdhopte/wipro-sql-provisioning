output "sql_server_id" {
  value = azurerm_mssql_server.sqlserver.id
}

output "sql_database_id" {
  value = azurerm_mssql_database.sqldb.id
}

# ── Confirmation outputs — useful for ServiceNow audit logs ──
output "resolved_admin_display_name" {
  description = "Display name of the resolved Azure AD admin"
  value       = local.sql_admin_display_name
}

output "resolved_admin_object_id" {
  description = "Object ID auto-fetched from Azure AD"
  value       = local.sql_admin_object_id
}

output "resolved_admin_upn" {
  description = "Normalized UPN from Azure AD"
  value       = local.sql_admin_upn
}