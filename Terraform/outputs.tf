output "resource_group_name" {
  description = "Name of the resource group hosting the RAG workload."
  value       = azurerm_resource_group.rag.name
}

output "storage_account_name" {
  description = "Name of the storage account for RAG artifacts."
  value       = azurerm_storage_account.rag.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault storing secrets for the RAG solution."
  value       = azurerm_key_vault.rag.vault_uri
}

# output "openai_endpoint" {
#   description = "Endpoint for the Azure OpenAI account hosting the GPT-5 deployment."
#   value       = azurerm_cognitive_account.rag.endpoint
# }

output "openai_deployment_name" {
  description = "Name of the GPT-5 Azure OpenAI deployment."
  value       = azurerm_cognitive_deployment.rag.name
}

output "ai_foundry_hub_name" {
  description = "Azure AI Foundry hub provisioned for the RAG workload."
  value       = azurerm_ai_foundry.hub.name
}

output "ai_foundry_project_name" {
  description = "Azure AI Foundry project name."
  value       = azurerm_ai_foundry_project.rag.name
}

# output "openai_key_secret_id" {
#   description = "ID of the Key Vault secret containing the Azure OpenAI key."
#   value       = var.store_openai_secret_in_key_vault ? azurerm_key_vault_secret.openai_primary_key[0].id : null
#   sensitive   = true
# }

# #############################################
# Outputs - Virtual Network
# #############################################

output "vnet_id" {
  description = "ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

# #############################################
# Outputs - Private Endpoints
# #############################################

output "private_endpoint_storage_blob_id" {
  description = "ID of the Storage Account Blob private endpoint."
  value       = azurerm_private_endpoint.storage_blob.id
}

output "private_endpoint_storage_file_id" {
  description = "ID of the Storage Account File private endpoint."
  value       = azurerm_private_endpoint.storage_file.id
}

output "private_endpoint_keyvault_id" {
  description = "ID of the Key Vault private endpoint."
  value       = azurerm_private_endpoint.keyvault.id
}

output "private_endpoint_ai_services_id" {
  description = "ID of the AI Services private endpoint."
  value       = azurerm_private_endpoint.ai_services.id
}

output "private_endpoint_ai_foundry_hub_id" {
  description = "ID of the AI Foundry Hub private endpoint."
  value       = azurerm_private_endpoint.ai_foundry_hub.id
}

# #############################################
# Outputs - Private DNS Zones
# #############################################

output "private_dns_zones" {
  description = "Map of Private DNS Zones created for private endpoints."
  value = {
    blob              = azurerm_private_dns_zone.blob.name
    file              = azurerm_private_dns_zone.file.name
    keyvault          = azurerm_private_dns_zone.keyvault.name
    cognitiveservices = azurerm_private_dns_zone.cognitiveservices.name
    ai_foundry        = azurerm_private_dns_zone.ai_foundry.name
    notebooks         = azurerm_private_dns_zone.notebooks.name
  }
}

# #############################################
# Outputs - Log Analytics
# #############################################

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.rag.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.rag.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key for the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.rag.primary_shared_key
  sensitive   = true
}
