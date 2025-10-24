resource "azurerm_key_vault" "rag" {
  name                = "${random_string.prefix.result}-${var.key_vault_name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = lower(var.key_vault_sku)

  # Habilitar RBAC para autorización
  rbac_authorization_enabled = true

  # Deshabilitar acceso público
  public_network_access_enabled = true

  tags = local.etiquetas_comunes

}

# Asignar el rol de Key Vault Administrator
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.rag.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
