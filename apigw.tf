# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "appGatewayConfig-beap"
  frontend_port_name             = "appGatewayConfig-feport"
  frontend_ip_configuration_name = "appGatewayConfig-feip"
  http_setting_name              = "appGatewayConfig-be-htst"
  listener_name                  = "appGatewayConfig-httplstn"
  request_routing_rule_name      = "appGatewayConfig-rqrt"
  app_gateway_subnet_name        = "appgwsubnet"
}

# Public Ip 
resource "azurerm_public_ip" "publicpip" {
  name                = "pip-qhatu-eastus-dev"
  location            = azurerm_resource_group.production.location
  resource_group_name = azurerm_resource_group.production.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = var.app_gateway_name
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location

  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = module.kube_network.subnet_ids["ingress-subnet"]
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.publicpip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10
  }

  depends_on = [module.kube_network, azurerm_public_ip.publicpip]
}

resource "azurerm_role_assignment" "ra4" {
  principal_id         = var.azurerm_client_id
  role_definition_name = "Owner"
  scope                = azurerm_resource_group.production.id
  depends_on           = [azurerm_user_assigned_identity.testIdentity, azurerm_application_gateway.network]
}