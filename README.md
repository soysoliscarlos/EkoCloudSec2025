# Demo: Infra privada de Azure AI + OPA + Vault

Este repo contiene tres piezas integradas para montar un entorno de IA en Azure con red privada y control de seguridad:

- `Terraform/`: Infraestructura en Azure (VNet, subnets, NSG, Private Endpoints, DNS privado, Log Analytics, AI Services/OpenAI, AI Foundry Hub/Project, Storage, Key Vault) y un conector administrado desde AI Foundry hacia Azure AI Services.
- `OPA/`: Política Rego que prohíbe exposición a Internet (public network access) y script para evaluar un plan de Terraform.
- `Vault/`: Configuración local de HashiCorp Vault para gestionar credenciales de Azure que Terraform consume sin exponer secretos en archivos.

A continuación verás cómo está armado, cómo ejecutarlo en Windows (PowerShell) y cómo validar que nada quede con acceso público.

## Arquitectura resumida

- Red
  - VNet principal con subnets para apps, datos, IA y una subnet dedicada a Private Endpoints
  - Peering con una VNet existente `Vnet-Ekoparty` (RG `RG-VM-Ekoparty`)
  - NSGs por subnet y diagnósticos a Log Analytics
  - Private Endpoints para: Storage (Blob/File), Key Vault, AI Services y AI Foundry Hub
  - Private DNS Zones enlazadas a la VNet local y a la VNet remota (peering)
- Servicios de datos y secretos
  - Storage Account (acceso público deshabilitado)
  - Key Vault (RBAC enabled). Nota: en el código base está el flag de acceso público en `true` a propósito para la demo (OPA lo detecta)
- Observabilidad
  - Log Analytics Workspace y Diagnostic Settings en Storage, Key Vault, AI Services, VNet, NSGs, AI Foundry Hub
- IA
  - Azure AI Services (Cognitive/OpenAI) con un deployment de modelo
  - Azure AI Foundry Hub + Project
  - Conexión administrada del workspace hacia AI Services vía `azapi_resource`

## Terraform

Ubicación: `Terraform/`

### Proveedores y autenticación

- Proveedores usados: `azurerm`, `azapi`, `vault`, `random` (ver `providers.tf`).
- Terraform obtiene credenciales de Azure desde Vault leyendo `kv/azure` (ver `data.tf`). Claves esperadas:
  - `tenant_id`, `subscription_id`, `client_id`, `client_secret`
- El proveedor `vault` se conecta a `http://127.0.0.1:8200` y usa `var.vault_token`.

### Recursos principales (archivos .tf)

- `resource_group.tf`: Resource Group
- `vnet.tf`: VNet, subnets, NSGs y asociaciones
- `private_endpoints.tf`: Private Endpoints + Private DNS Zones y VNet Links (local y remota)
- `storage.tf`: Storage Account + Container (acceso público deshabilitado)
- `key_vault.tf`: Key Vault (RBAC). Nota: `public_network_access_enabled = true` intencional para demostrar la política OPA
- `ai_services.tf`: Azure AI Services + `azurerm_cognitive_deployment`
- `ai_foundry.tf`: AI Foundry Hub + Project y rol `Key Vault Secrets Officer`
- `ai_connector.tf`: Conexión administrada (AzAPI) que expone AI Services en el hub
- `log_analytics.tf`: Log Analytics y Diagnostic Settings
- `peering.tf`: Peering entre la VNet local y `Vnet-Ekoparty`
- `outputs.tf`: Salidas útiles (ids, nombres, DNS zones, etc.)
- `variables.tf` y `locals.tf`: variables de entrada y etiquetas comunes
- `backend.tf`: backend local por defecto; puedes migrar a remoto con `backend.hcl.example`

### Variables clave (extracto)

- Despliegue y tagging: `environment`, `tags`
- RG y región: `resource_group_name`, `location`
- Red: `vnet_name`, `vnet_address_space`, `subnets` (mapa con name/prefixes/optional delegation)
- Storage: `storage_account_name`, `container_name`, `container_access_type`
- Key Vault: `key_vault_name`, `key_vault_sku`
- AI Services/OpenAI: `ai_services_name`, `ai_services_custom_subdomain_name`, `openai_*`
- AI Foundry: `ai_foundry_hub_name`, `ai_foundry_project_name`
- Observabilidad: `log_analytics_*`
- Vault: `vault_token` (sensible)

Revisa `Terraform/terraform.tfvars.example` para un ejemplo de valores. Nota: las credenciales de Azure no van en `.tfvars`, van en Vault.

### Backend remoto (opcional)

1. Copia `Terraform/backend.hcl.example` a `Terraform/backend.hcl` y ajusta nombres de RG, Storage, Container y key
2. Re-inicializa usando el backend remoto:

```powershell
cd ./Terraform
terraform init -migrate-state -backend-config="backend.hcl"
```

### Flujo de ejecución

1. Levanta Vault y carga credenciales (ver sección Vault)
2. Exporta el token de Vault para Terraform

```powershell
$env:TF_VAR_vault_token = "<TOKEN_VAULT>"
```

3. Inicializa, planifica y aplica

```powershell
cd ./Terraform
terraform init
terraform plan -out tfplan.bin
terraform apply tfplan.bin
```

4. (Opcional) Genera/actualiza el plan en JSON para OPA

```powershell
./regen_plan.ps1                  # crea tfplan.bin y plan.json
```

## OPA (Open Policy Agent)

Ubicación: `OPA/`

- Política: `deny_public_internet.rego` (paquete `terraform.deny_public_internet`)
  - Revisa recursos del plan (`tfplan/v2`) y emite violaciones si encuentra:
    - `public_network_access != "Disabled"` o `public_network_access_enabled = true`
    - `allow_blob_public_access = true` en Storage
    - Key Vault con `network_acls` no restrictivo
    - NSGs con reglas outbound `Allow` hacia `Internet`/`0.0.0.0/0` o sin regla `Deny` a Internet
- Script helper: `opa_eval_red.ps1` ejecuta `opa eval` y muestra solo los mensajes en rojo.

### Cómo evaluar el plan con OPA

Asegúrate de tener `plan.json` generado desde `Terraform/`.

```powershell
cd ./OPA
./opa_eval_red.ps1 --input ..\Terraform\plan.json --data .\deny_public_internet.rego --fail-defined "data.terraform.deny_public_internet.violations"
# o para listar las violaciones (mensajes):
./opa_eval_red.ps1 --input ..\Terraform\plan.json --data .\deny_public_internet.rego "data.terraform.deny_public_internet.deny"
```

- Salida vacía: no hay violaciones
- Salida en rojo: revisa y corrige flags de acceso público

Sugerencia: en esta demo, Key Vault y AI Services dejan intención de violación para que veas la política en acción.

## Vault (HashiCorp)

Ubicación: `Vault/`

- Configuración: `config/vault.hcl` (almacenamiento en filesystem, listener TCP sin TLS, UI habilitada)
- Estado de datos: el resto de carpetas/archivos son el data dir de Vault (no publiques estos secretos)
- Archivo `init.txt` contiene llaves de unseal y un root token de ejemplo PARA DEMO. No uses esto en producción.

### Arranque rápido en Windows (dev local)

1. Abre una terminal y levanta Vault con la config incluida

```powershell
cd ./Vault
vault server -config .\config\vault.hcl
```

2. En otra terminal, exporta la dirección y autentícate con un token (usa uno nuevo si lo rotaste)

```powershell
$env:VAULT_ADDR = "http://127.0.0.1:8200"
vault login
```

3. Habilita (si no existe) el motor KV v2 en `kv/` y guarda credenciales de Azure consumidas por Terraform

```powershell
vault secrets enable -path=kv kv-v2    # idempotente; ignora si ya existe
vault kv put kv/azure tenant_id="<TENANT>" subscription_id="<SUBSCRIPTION>" client_id="<APP_ID>" client_secret="<PASSWORD>"
```

4. Exporta el token para Terraform

```powershell
$env:TF_VAR_vault_token = (vault token lookup -format=json | jq -r .data.id)
# o asigna manualmente: $env:TF_VAR_vault_token = "<TOKEN>"
```

Seguridad:

- Rotar y no commitear tokens/keys. El `init.txt` es solo demostrativo.
- Usa TLS y políticas en Vault para cualquier uso real.

## Solución de problemas

- Autenticación Azure: "The subscription is not registered" o 401
  - Verifica que Vault esté arriba y `kv/azure` tenga `tenant_id`, `subscription_id`, `client_id`, `client_secret`
  - Asegúrate de exportar `TF_VAR_vault_token`
- OPA falla con violaciones
  - Corrige flags: en Storage deshabilita `allow_blob_public_access` y `public_network_access(_enabled)`
  - En Key Vault, ajusta `public_network_access(_enabled)` y `network_acls` (default Deny, bypass None)
  - En AI Services/Foundry, deshabilita acceso público
- DNS/Resolución privada
  - Revisa los `private_dns_zone_virtual_network_link` para la VNet local y la VNet remota
- Permisos
  - El principal usado debe tener permisos suficientes (Owner/Contributor) para crear todos los recursos

## Referencias rápidas

- Ver listado detallado en `Terraform/README.md`
- Documentación de proveedores Terraform: azurerm, azapi, vault, random
- OPA (tfplan/v2): <https://www.openpolicyagent.org/>
- Vault: <https://developer.hashicorp.com/vault>

---

Hecho para la demo de EkoParty 2025. Ajusta nombres/regiones según tu suscripción.
