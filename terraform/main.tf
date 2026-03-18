provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "devops-rg"
  location = "Central India"
}

# App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "devops-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}

# App Service
resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = "3.11"
    }

    # VERY IMPORTANT (this fixes 90% deployment issues)
    app_command_line = "bash startup.sh"
  }

  app_settings = {
    "WEBSITES_PORT" = "8000"
  }
}

# Staging Slot
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      python_version = "3.11"
    }

    app_command_line = "bash startup.sh"
  }

  app_settings = {
    "WEBSITES_PORT" = "8000"
  }
}