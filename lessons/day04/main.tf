terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    # Export your ARM_ACCESS_KEY before running this tf file.
    storage_account_name = "day048537"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
    features {
      
    }
  
}



resource "azurerm_resource_group" "rg" {
  name     = "sampletest-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageaccount2205"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "test"
  }
}