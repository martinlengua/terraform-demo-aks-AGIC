resource "azurerm_container_registry" "acrquickcomm" {
  name                = "devqhatuacrserver"
  resource_group_name = azurerm_resource_group.production.name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true
}