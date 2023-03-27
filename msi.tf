# User Assigned Identities 
resource "azurerm_user_assigned_identity" "testIdentity" {
  name                = var.msiname
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location
}