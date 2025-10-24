# Escenario 7 – Conector de Azure AI Foundry

Crea una conexión administrada en Azure AI Foundry que expone Azure AI Services mediante el proveedor AzAPI.

## Características de Red Privada

Esta infraestructura implementa una arquitectura de red segura con las siguientes características:

### Virtual Network (VNet)
- **VNet principal** con espacio de direcciones configurable
- **Subnets dedicadas**:
  - `subnet-app`: Para aplicaciones (10.0.1.0/24)
  - `subnet-data`: Para datos (10.0.2.0/24)
  - `subnet-ai`: Para servicios de IA (10.0.3.0/24)
  - `subnet-private-endpoints`: Para endpoints privados (10.0.4.0/24)

### Private Endpoints
Se crean private endpoints para todos los recursos críticos:
- **Storage Account**: Blob y File endpoints
- **Key Vault**: Acceso seguro a secretos
- **AI Services**: Cognitive Services endpoint
- **AI Foundry Hub**: Workspace endpoint con notebooks

### Private DNS Zones
Zonas DNS privadas con vnet links automáticos:
- `privatelink.blob.core.windows.net` - Storage Blobs
- `privatelink.file.core.windows.net` - Storage Files
- `privatelink.vaultcore.azure.net` - Key Vault
- `privatelink.cognitiveservices.azure.com` - AI Services
- `privatelink.api.azureml.ms` - AI Foundry
- `privatelink.notebooks.azure.net` - AI Foundry Notebooks

### Seguridad de Red
- **Acceso público deshabilitado** en Storage Account y Key Vault
- **Network ACLs** configuradas en AI Services (default: Deny)
- **NSGs** asociados a cada subnet
- **Service Endpoints** configurados para servicios críticos

## Bloques de Terraform utilizados
- Bloque `terraform` con backend `azurerm`: https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
- Proveedor `azurerm`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- Proveedor `azapi`: https://registry.terraform.io/providers/Azure/azapi/latest/docs
- Proveedor `random`: https://registry.terraform.io/providers/hashicorp/random/latest/docs
- Bloque `locals`: https://developer.hashicorp.com/terraform/language/values/locals
- Data source `azurerm_client_config`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
- Recurso `random_string`: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
- Recurso `azurerm_resource_group`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
- Recurso `azurerm_storage_account`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
- Recurso `azurerm_storage_container`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
- Recurso `azurerm_key_vault`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
- Recurso `azurerm_role_assignment`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
- Recurso `azurerm_ai_services`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services
- Recurso `azurerm_cognitive_deployment`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment
- Recurso `azurerm_ai_foundry`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry
- Recurso `azurerm_ai_foundry_project`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry_project
- Recurso `azapi_resource`: https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource
- Recurso `azurerm_virtual_network`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
- Recurso `azurerm_subnet`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
- Recurso `azurerm_network_security_group`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
- Recurso `azurerm_subnet_network_security_group_association`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
- Recurso `azurerm_private_endpoint`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
- Recurso `azurerm_private_dns_zone`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
- Recurso `azurerm_private_dns_zone_virtual_network_link`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
- Bloques `output`: https://developer.hashicorp.com/terraform/language/values/outputs

## Prerrequisitos

- Instala [Terraform](https://developer.hashicorp.com/terraform/install)
- Instala [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
