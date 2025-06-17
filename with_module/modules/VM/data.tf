data "azurerm_subnet" "example" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "example" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
}


data "azurerm_key_vault" "example" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
