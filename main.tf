terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  name     = "user_0LI23NQ99U_ResourceGroup"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "demmitothemoon"
  resource_group_name      = local.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service-plan" {
  name                = "app-service-plan"
  resource_group_name = local.name
  location            = local.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "app" {
  name                = "linux-function-app"
  resource_group_name = local.name
  location            = local.location

  storage_account_name = azurerm_storage_account.storage.name
  service_plan_id      = azurerm_service_plan.service-plan.id

  site_config {}
}
