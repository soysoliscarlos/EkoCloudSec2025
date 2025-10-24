provider "azurerm" {
  tenant_id       = data.vault_kv_secret_v2.azure.data["tenant_id"]
  subscription_id = data.vault_kv_secret_v2.azure.data["subscription_id"]
  client_id       = data.vault_kv_secret_v2.azure.data["client_id"]
  client_secret   = data.vault_kv_secret_v2.azure.data["client_secret"]
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azapi" {
  tenant_id       = data.vault_kv_secret_v2.azure.data["tenant_id"]
  subscription_id = data.vault_kv_secret_v2.azure.data["subscription_id"]
  client_id       = data.vault_kv_secret_v2.azure.data["client_id"]
  client_secret   = data.vault_kv_secret_v2.azure.data["client_secret"]
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}
