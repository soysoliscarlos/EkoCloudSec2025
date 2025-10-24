data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "vnet-vm" {
  name                = "Vnet-Ekoparty"
  resource_group_name = "RG-VM-Ekoparty"
}

data "vault_kv_secret_v2" "azure" {
  mount = "kv"
  name  = "azure"
}
