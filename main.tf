terraform {
  required_version = ">= 0.12.24"
}

# Configure the Azure Provider
provider "azurerm" {
  features{}

  subscription_id = var.azurerm_subscription_id
  tenant_id       = var.azurerm_tenant_id
  client_id       = var.azurerm_client_id
  client_secret   = var.azurerm_client_secret
}

resource "azurerm_resource_group" "production" {
  name     = var.resource_name
  location = var.location

  tags = {
    environment = "AKS for Testing"
  }

}