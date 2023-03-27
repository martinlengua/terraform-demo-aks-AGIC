terraform {
  required_version = ">= 0.12.24"
}

data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = var.kube_version_prefix
}

resource "azurerm_kubernetes_cluster" "aksprod" {
  name                = "dev-qhatu-aks-server"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  location            = var.location
  resource_group_name = azurerm_resource_group.production.name
  dns_prefix          = "dev-qhatu-aks-server-k8s"
  private_cluster_enabled = true

  default_node_pool {
    name            = "systemnode"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
    vnet_subnet_id = module.kube_network.subnet_ids["aks-subnet"]
  }

  linux_profile {
    admin_username = var.vm_user_name

    ssh_key {
      key_data = file(var.public_ssh_key_path)
    }
  }

  service_principal {
    client_id     = var.azurerm_client_id
    client_secret = var.azurerm_client_secret
 }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.network_dns_service_ip
    docker_bridge_cidr = var.network_docker_bridge_cidr
    outbound_type      = "userDefinedRouting"
    service_cidr       = var.network_service_cidr
  }

  depends_on = [module.routetable, module.kube_network, azurerm_application_gateway.network]

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "appnode" {
  name                  = "devqhatuapp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aksprod.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  vnet_subnet_id = module.kube_network.subnet_ids["aks-subnet"]
}

resource "azurerm_role_assignment" "iamaks" {
  principal_id                     = var.azurerm_client_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acrquickcomm.id
  skip_service_principal_aad_check = true
}