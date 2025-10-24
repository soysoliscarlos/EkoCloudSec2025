# #############################################
# Log Analytics Workspace
# #############################################

resource "azurerm_log_analytics_workspace" "rag" {
  name                = "${random_string.prefix.result}-${var.log_analytics_name}"
  location            = azurerm_resource_group.rag.location
  resource_group_name = azurerm_resource_group.rag.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days

  tags = local.etiquetas_comunes
}

# #############################################
# Diagnostic Settings
# #############################################

# Storage Account Diagnostic Settings
# Note: Storage accounts don't support log categories at the account level
# Logs are available at the service level (blob, file, queue, table)
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "diag-${azurerm_storage_account.rag.name}"
  target_resource_id         = azurerm_storage_account.rag.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_metric {
    category = "Transaction"
  }

  enabled_metric {
    category = "Capacity"
  }
}

# Key Vault Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "diag-${azurerm_key_vault.rag.name}"
  target_resource_id         = azurerm_key_vault.rag.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# AI Services Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "ai_services" {
  name                       = "diag-${azurerm_ai_services.rag.name}"
  target_resource_id         = azurerm_ai_services.rag.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "RequestResponse"
  }

  enabled_log {
    category = "Trace"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# AI Foundry Hub Diagnostic Settings
# Note: Using only metrics as log categories may vary by region/configuration
resource "azurerm_monitor_diagnostic_setting" "ai_foundry_hub" {
  name                       = "diag-${azurerm_ai_foundry.hub.name}"
  target_resource_id         = azurerm_ai_foundry.hub.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Virtual Network Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vnet" {
  name                       = "diag-${azurerm_virtual_network.vnet.name}"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Network Security Group Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "nsg" {
  for_each = var.subnets

  name                       = "diag-${azurerm_network_security_group.nsg[each.key].name}"
  target_resource_id         = azurerm_network_security_group.nsg[each.key].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rag.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}
