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
  name     = "user_YURQJATTW7_ResourceGroup"
  location = "West Europe"
}

resource "azurerm_servicebus_namespace" "example" {
  name                = "servicebus-namespacerse"
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

resource "azurerm_servicebus_namespace_authorization_rule" "example" {
  name         = "examplerule"
  namespace_id = azurerm_servicebus_namespace.example.id

  listen = true
  send   = true
  manage = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "demmierthewa"
  resource_group_name      = local.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "service-plan" {
  name                = "app-service-plan-tt"
  resource_group_name = local.name
  location            = local.location
  kind                = "FunctionApp"
  reserved = true # this has to be set to true for Linux. Not related to the Premium Plan
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  os_type             = "Linux"
}

resource "azurerm_linux_function_app" "app" {
  name                = "linux-function-app-for-azure"
  resource_group_name = local.name
  location            = local.location

  storage_account_name = azurerm_storage_account.storage.name
  service_plan_id      = azurerm_service_plan.service-plan.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "__init__.py.zip",
    "FUNCTIONS_WORKER_RUNTIME" = "node",
    "AzureWebJobsDisableHomepage" = "true",
  }
  site_config {}
}

# resource "azurerm_function_app_function" "func" {
#   name            = "first-func"
#   function_app_id = azurerm_linux_function_app.app.id
#   language        = "Python"
  
# #   file {
# #     name    = "run py"
# #     content = file("__init__.py")
# #   }
 
#   config_json = jsonencode({
#     "scriptFile": "__init__.py",
#     "bindings": [
#         {
#             "authLevel": "function",
#             "type": "httpTrigger",
#             "direction": "in",
#             "name": "req",
#             "methods": [
#                 "get",
#                 "post"
#             ]
#         },
#         {
#             "type": "http",
#             "direction": "out",
#             "name": "$return"
#         }
#     ]
#   })
# }

