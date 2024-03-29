# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#     }
#   }
# }

# provider "aws" {
#     region = "us-west-2"
# }

terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "folidiere"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  name     = "user_HG6KAQ52Q2_ResourceGroup"
  location = "West Europe"
}

# resource "azurerm_servicebus_namespace" "example" {
#   name                = "servicebus-namespacerse"
#   location            = local.location
#   resource_group_name = local.name
#   sku                 = "Standard"

#   tags = {
#     source = "terraform"
#   }
# }

# resource "azurerm_servicebus_queue" "example" {
#   name         = "servicebus-queue"
#   namespace_id = azurerm_servicebus_namespace.example.id

#   enable_partitioning = true
# }

# resource "azurerm_servicebus_namespace_authorization_rule" "example" {
#   name         = "examplerule"
#   namespace_id = azurerm_servicebus_namespace.example.id

#   listen = true
#   send   = true
#   manage = false
# }

# resource "azurerm_storage_account" "storage" {
#   name                     = "demmierthewa"
#   resource_group_name      = local.name
#   location                 = local.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_service_plan" "service-plan" {
#   name                = "app-service-plan-tt"
#   resource_group_name = local.name
#   location            = local.location
#   os_type             = "Linux"
#   sku_name            = "Y1"
# }

# resource "azurerm_linux_function_app" "app" {
#   name                = "linux-function-app-for-azure"
#   resource_group_name = local.name
#   location            = local.location

#   storage_account_name = azurerm_storage_account.storage.name
#   service_plan_id      = azurerm_service_plan.service-plan.id
 
#   site_config {}
# }

# resource "azurerm_function_app_function" "func" {
#   name            = "first-func"
#   function_app_id = azurerm_linux_function_app.app.id
#   language        = "Python"
  
# #   file {
# #     name    = "run py"
# #     content = file("__init__.py")
# #   }
 
#   config_json = jsonencode({
# #     "scriptFile": "__init__.py",
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



resource "azurerm_storage_account" "example" {
  name                     = "storgaeers"
  resource_group_name      = local.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                = "service-planerrs"
  location            = local.location
  resource_group_name = local.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "azure-rishap-function-app"
  location            = local.location
  resource_group_name = local.name
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}

resource "azurerm_function_app_function" "example" {
  name            = "example-function-app-function"
  function_app_id = azurerm_linux_function_app.example.id
  language        = "Python"
  test_data = jsonencode({
    "name" = "Azure"
  })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}

