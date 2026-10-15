
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-fastapi-prod"
  location = var.location
}

# Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
}


# 3. Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-fastapi-logs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 4. Container Apps Environment
resource "azurerm_container_app_environment" "env" {
  name                       = "cae-fastapi-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

# 5. Container App (FastAPI Deployment)
resource "azurerm_container_app" "app" {
  name                         = "ca-fastapi-service"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  # Managed Identity to securely pull secrets from Key Vault without hardcoded credentials
  identity {
    type = "SystemAssigned"
  }

  template {
    min_replicas = 1
    max_replicas = 3


    container {
      name   = "fastapi"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest" # Replace with your container registry image (e.g., ACR)
      cpu    = "0.5"
      memory = "1.0Gi"

      # Environment variables referencing secrets safely
      env {
        name  = "PORT"
        value = "8000"
      }

      env {
        name  = "DB_USER"
        value = "https://${var.key_vault_name}.vault.azure.net/secrets/db-user"
      }

      env {
        name  = "DB_PASSWORD"
        value = "https://${var.key_vault_name}.vault.azure.net/secrets/db-password"
      }

      env {
        name  = "JWT_SECRET"
        value = "https://${var.key_vault_name}.vault.azure.net/secrets/jwt-secret"
      }

      env {
        name  = "JWT_ALGORITHM"
        value = "HS256"
      }


      env {
        name  = "DB_URL"
        value = "https://${var.key_vault_name}.vault.azure.net/secrets/db-url"
      }

      env {
        name  = "ADMIN_API_KEY"
        value = "https://${var.key_vault_name}.vault.azure.net/secrets/admin-api-key"
      }


    }

  }

  ingress {
    external_enabled = true
    target_port      = 8000
    transport        = "auto"

    # Restrict Network Ingress: Optional IP security restrictions can be added here
    # ip_security_restriction {
    #   name             = "AllowSpecificOffice"
    #   action           = "Allow"
    #   ip_address_range = "192.168.1.0/24"
    # }

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
