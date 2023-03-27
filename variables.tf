
variable "azurerm_subscription_id" {
  type = string
  default = "XXXXX"
}

variable "azurerm_tenant_id" {
  type = string
  default = "XXXXX"
}

variable "azurerm_client_id" {
  type = string
  default = "XXXXX"
}

variable "azurerm_client_secret" {
  type = string
  default = "XXXXXX"
}

variable "resource_name" {
  type    = string
  default = "Define your name"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type    = string
  default = "East US"
}

variable "network_docker_bridge_cidr" {
  description = "Docker bridge cidr"
  default     = "182.11.0.1/16"
}

variable "network_dns_service_ip" {
  description = "DNS service IP"
  default     = "11.0.0.10"
}

variable "network_service_cidr" {
  description = "service cidr"
  default     = "19.0.0.0/16"
}

variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "Define your name"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "Define your name"
}

variable "kube_version_prefix" {
  description = "AKS Kubernetes version prefix. Formatted '[Major].[Minor]' like '1.18'. Patch version part (as in '[Major].[Minor].[Patch]') will be set to latest automatically."
  default     = "1.24"
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  default     = "Define your name"
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}

variable "public_ssh_key_path" {
  description = "Public key path for SSH."
  default     = "~/.ssh/id_rsa.pub"
}

variable "aks_enable_rbac" {
  description = "Enable RBAC on the AKS cluster. Defaults to false."
  default     = "false"
}

variable "msiname" {
  description = "Name of the MSI."
  default     = "Define your name"
}