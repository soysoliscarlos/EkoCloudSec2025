resource "azurerm_ai_services" "rag" {
  name                  = "${random_string.prefix.result}-${var.ai_services_name}"
  location              = azurerm_resource_group.rag.location
  resource_group_name   = azurerm_resource_group.rag.name
  sku_name              = var.ai_services_sku_name
  custom_subdomain_name = "${random_string.prefix.result}${var.ai_services_custom_subdomain_name}"
  public_network_access = "Enabled"
  # public_network_access = "Disabled"

  # Habilitar identidad administrada
  identity {
    type = "SystemAssigned"
  }

  tags = local.etiquetas_comunes
}

resource "azurerm_cognitive_deployment" "rag" {
  name                 = var.openai_deployment_name
  cognitive_account_id = azurerm_ai_services.rag.id

  model {
    format  = "OpenAI"
    name    = var.openai_model_name
    version = var.openai_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.openai_scale_capacity
  }
}
