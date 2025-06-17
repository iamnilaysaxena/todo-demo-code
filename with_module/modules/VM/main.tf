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
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "example" {
  name         = var.secret_key_name
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  admin_password                  = data.azurerm_key_vault_secret.example.value
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
