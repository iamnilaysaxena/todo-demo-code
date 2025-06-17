resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "azurerm_key_vault" "example" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_key_vault_secret" "example" {
  name         = var.secret_key_name
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_mssql_server" "example" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = random_password.password.result
}

resource "azurerm_mssql_database" "example" {
  name         = var.db_name
  server_id    = azurerm_mssql_server.example.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}
