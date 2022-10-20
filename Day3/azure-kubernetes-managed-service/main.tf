terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~>3.0"
    }

    tls = {
        source = "hashicorp/tls"
        version = "~>4.0"
    }
 }
}

provider "azurerm" {
  features {}
}

variable "resource_group_location" {
  description = "Location of the resource group"
  default = "eastus"
}

variable "resource_group_name_prefix" {
    default = "rg"
    description = "Prefix of resource group"
}

resource "random_pet" "rg_name" {
   prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = random_pet.rg_name.id
    depends_on = [
        random_pet.rg_name
    ]
}

resource "azurerm_kubernetes_cluster" "my-aks" {
  name                = "tektutor-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "tektutor"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.my-aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.my-aks.kube_config_raw
  sensitive = true
}
