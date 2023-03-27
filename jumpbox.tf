module "jumpbox" {
  source                  = "./modules/jumpbox"
  location                = var.location
  resource_group          = azurerm_resource_group.production.name
  vnet_id                 = module.hub_network.vnet_id
  subnet_id               = module.hub_network.subnet_ids["jumpbox-subnet"]
  dns_zone_name           = join(".", slice(split(".", azurerm_kubernetes_cluster.aksprod.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.aksprod.private_fqdn))))
  dns_zone_resource_group = azurerm_kubernetes_cluster.aksprod.node_resource_group
}