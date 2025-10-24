resource "azurerm_ai_foundry" "hub" {
  name                = "${random_string.prefix.result}-${var.ai_foundry_hub_name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  storage_account_id  = azurerm_storage_account.rag.id
  key_vault_id        = azurerm_key_vault.rag.id
  tags                = local.etiquetas_comunes

  identity {
    type = "SystemAssigned"
  }

  public_network_access = "Disabled"

  lifecycle {
    # Ignorar cambios en tags que comiencen con __SYSTEM__
    ignore_changes = [
      tags,
    ]
  }
}

# Asignar el rol de Key Vault Secrets Officer
resource "azurerm_role_assignment" "ai_services_secrets_officer" {
  scope                = azurerm_key_vault.rag.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

resource "azurerm_ai_foundry_project" "rag" {
  name               = "${random_string.prefix.result}-${var.ai_foundry_project_name}"
  location           = azurerm_resource_group.rag.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id
  tags               = local.etiquetas_comunes

  identity {
    type = "SystemAssigned"
  }
}
