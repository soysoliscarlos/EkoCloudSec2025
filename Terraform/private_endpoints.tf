# #############################################
# Private DNS Zones
# #############################################

# DNS Zone para Storage Account (Blob)
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para Storage Account (File)
resource "azurerm_private_dns_zone" "file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para Key Vault
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para Cognitive Services (AI Services)
resource "azurerm_private_dns_zone" "cognitiveservices" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para Azure OpenAI
resource "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para AI Foundry Hub
resource "azurerm_private_dns_zone" "ai_foundry" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# DNS Zone para AI Foundry Notebooks
resource "azurerm_private_dns_zone" "notebooks" {
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = azurerm_resource_group.rag.name
  tags                = local.etiquetas_comunes
}

# #############################################
# Virtual Network Links para Private DNS Zones
# #############################################

resource "azurerm_private_dns_zone_virtual_network_link" "blob_link" {
  name                  = "blob-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "file_link" {
  name                  = "file-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_link" {
  name                  = "keyvault-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "cognitiveservices_link" {
  name                  = "cognitiveservices-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.cognitiveservices.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_link" {
  name                  = "openai-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "ai_foundry_link" {
  name                  = "ai-foundry-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.ai_foundry.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "notebooks_link" {
  name                  = "notebooks-vnet-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.notebooks.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

# #############################################
# Virtual Network Links to remote VNet (data.azurerm_virtual_network.vnet-vm)
# #############################################

resource "azurerm_private_dns_zone_virtual_network_link" "blob_link_vm" {
  name                  = "blob-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "file_link_vm" {
  name                  = "file-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.file.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_link_vm" {
  name                  = "keyvault-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "cognitiveservices_link_vm" {
  name                  = "cognitiveservices-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.cognitiveservices.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_link_vm" {
  name                  = "openai-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "ai_foundry_link_vm" {
  name                  = "ai-foundry-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.ai_foundry.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

resource "azurerm_private_dns_zone_virtual_network_link" "notebooks_link_vm" {
  name                  = "notebooks-vnet-vm-link"
  resource_group_name   = azurerm_resource_group.rag.name
  private_dns_zone_name = azurerm_private_dns_zone.notebooks.name
  virtual_network_id    = data.azurerm_virtual_network.vnet-vm.id
  registration_enabled  = false
  tags                  = local.etiquetas_comunes
}

# #############################################
# Private Endpoint - Storage Account (Blob)
# #############################################

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-${azurerm_storage_account.rag.name}-blob"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  subnet_id           = azurerm_subnet.subnet["subnet_private_endpoints"].id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.rag.name}-blob"
    private_connection_resource_id = azurerm_storage_account.rag.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = local.etiquetas_comunes
}

# #############################################
# Private Endpoint - Storage Account (File)
# #############################################

resource "azurerm_private_endpoint" "storage_file" {
  name                = "pe-${azurerm_storage_account.rag.name}-file"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  subnet_id           = azurerm_subnet.subnet["subnet_private_endpoints"].id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.rag.name}-file"
    private_connection_resource_id = azurerm_storage_account.rag.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.file.id]
  }

  tags = local.etiquetas_comunes
}

# #############################################
# Private Endpoint - Key Vault
# #############################################

resource "azurerm_private_endpoint" "keyvault" {
  name                = "pe-${azurerm_key_vault.rag.name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  subnet_id           = azurerm_subnet.subnet["subnet_private_endpoints"].id

  private_service_connection {
    name                           = "psc-${azurerm_key_vault.rag.name}"
    private_connection_resource_id = azurerm_key_vault.rag.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-keyvault"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  tags = local.etiquetas_comunes
}

# #############################################
# Private Endpoint - AI Services (Cognitive Services)
# #############################################

resource "azurerm_private_endpoint" "ai_services" {
  name                = "pe-${azurerm_ai_services.rag.name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  subnet_id           = azurerm_subnet.subnet["subnet_private_endpoints"].id

  private_service_connection {
    name                           = "psc-${azurerm_ai_services.rag.name}"
    private_connection_resource_id = azurerm_ai_services.rag.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdns-group-ai-services"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.cognitiveservices.id,
      azurerm_private_dns_zone.openai.id
    ]
  }

  tags = local.etiquetas_comunes
}

# #############################################
# Private Endpoint - AI Foundry Hub
# #############################################

resource "azurerm_private_endpoint" "ai_foundry_hub" {
  name                = "pe-${azurerm_ai_foundry.hub.name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  subnet_id           = azurerm_subnet.subnet["subnet_private_endpoints"].id

  private_service_connection {
    name                           = "psc-${azurerm_ai_foundry.hub.name}"
    private_connection_resource_id = azurerm_ai_foundry.hub.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdns-group-ai-foundry"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.ai_foundry.id,
      azurerm_private_dns_zone.notebooks.id
    ]
  }

  tags = local.etiquetas_comunes
}
