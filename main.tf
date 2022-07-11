terraform{
  required_providers{
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azureum"{
  features{}
}

resource "azurerm_resources_group" "rg" {
  name = "first-rg"
  location = "Southeast Asia"
}
