module "rg" {
  source   = "../../modules/RG"
  name     = "rg-todo-app-dev"
  location = "Central India"
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../../modules/VNET"
  name                = "todo-vnet-dev"
  location            = "Central India"
  resource_group_name = "rg-todo-app-dev"
  address_space       = ["10.60.0.0/16"]
}

module "subnet_fe" {
  depends_on           = [module.vnet]
  source               = "../../modules/SUBNET"
  name                 = "fe-subnet"
  resource_group_name  = "rg-todo-app-dev"
  virtual_network_name = "todo-vnet-dev"
  address_prefixes     = ["10.60.0.0/24"]
}

module "subnet_be" {
  depends_on           = [module.vnet]
  source               = "../../modules/SUBNET"
  name                 = "be-subnet"
  resource_group_name  = "rg-todo-app-dev"
  virtual_network_name = "todo-vnet-dev"
  address_prefixes     = ["10.60.1.0/24"]
}

module "pip_fe" {
  depends_on          = [module.rg]
  source              = "../../modules/PIP"
  name                = "fe-pip"
  resource_group_name = "rg-todo-app-dev"
  location            = "Central India"
}

module "pip_be" {
  depends_on          = [module.rg]
  source              = "../../modules/PIP"
  name                = "be-pip"
  resource_group_name = "rg-todo-app-dev"
  location            = "Central India"
}

module "vm_fe" {
  depends_on           = [module.subnet_fe, module.pip_fe, module.kv]
  source               = "../../modules/VM"
  nic_name             = "fe-nic"
  vm_name              = "fe-vm"
  resource_group_name  = "rg-todo-app-dev"
  location             = "Central India"
  subnet_name          = "fe-subnet"
  pip_name             = "fe-pip"
  virtual_network_name = "todo-vnet-dev"
  key_vault_name       = "kv-todo-6060"
  secret_key_name      = "FE-VM-PASSWORD"
}

module "kv" {
  depends_on          = [module.rg]
  source              = "../../modules/KV"
  name                = "kv-todo-6060"
  resource_group_name = "rg-todo-app-dev"
  location            = "Central India"
}

module "db" {
  depends_on          = [module.kv]
  source              = "../../modules/DATABASE"
  name                = "todo-db-server"
  resource_group_name = "rg-todo-app-dev"
  location            = "Central India"
  key_vault_name      = "kv-todo-6060"
  secret_key_name     = "TODO-DB-PASSWORD"
  db_name             = "todo-db"
}
