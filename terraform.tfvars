resource_group_name = "ramu-rg"
location            = "centralindia"

sql_server_name = "ramu-sqlserver-demo"
sql_db_name     = "ramu-sqldb-demo"

sql_azuread_login = "ramanuja_translab.io#EXT#@wtest658gmail.onmicrosoft.com"

# ── Pass via CI/CD secrets, NOT hardcoded ────
sql_local_admin_username = "azureadmin"
sql_local_admin_password = "qazwsx@12345678"

sku_tier     = "GeneralPurpose"
compute_tier = "serverless"

pitr_diff_backup_interval_in_hours = 12
pitr_retention_days                = 7

ltr_weekly_retention = "P1W"
ltr_monthly_retention = "P1M"
ltr_yearly_retention  = "P1Y"
ltr_week_of_year      = 1

resource_tags = {
  Environment = "prod"
  Owner       = "CloudTeam"
}