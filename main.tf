provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource" {
  name     = "azure-functions-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "demmetothemoon"
  resource_group_name      = azurerm_resource_group.resource.name
  location                 = azurerm_resource_group.resource.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "service_plan" {
  name                = "azure-functions-service-plan"
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "azure-functions"
  location                   = azurerm_resource_group.resource.location
  resource_group_name        = azurerm_resource_group.resource.name
  app_service_plan_id        = azurerm_app_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
}
