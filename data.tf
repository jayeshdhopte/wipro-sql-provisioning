data "azuread_user" "sql_admin" {
  user_principal_name = var.sql_azuread_login
}
