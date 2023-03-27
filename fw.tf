module "firewall" {
  source         = "./modules/firewall"
  resource_group = azurerm_resource_group.production.name
  location       = var.location
  pip_name       = "azureFirewalls-ip"
  fw_name        = "kubenetfw"
  subnet_id      = module.hub_network.subnet_ids["AzureFirewallSubnet"]
}
