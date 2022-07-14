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
  name     = "user_24J35D37CA_ResourceGroup"
  location = "West Europe"
}

resource "azurerm_servicebus_namespace" "example" {
  name                = "servicebus-namespace"
  location            = local.location
  resource_group_name = local.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

resource "azurerm_servicebus_queue" "example" {
  name         = "servicebus-queue"
  namespace_id = azurerm_servicebus_namespace.example.id

  enable_partitioning = true
}

resource "azurerm_storage_account" "storage" {
  name                     = "demmier"
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
