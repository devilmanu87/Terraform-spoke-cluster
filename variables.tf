#################################### AKS Cluster input Variables Section ###########################################################

# AKS Cluster variable declaration 
variable "dns_prefix" {
  type        = string
  description = "dns_prefix"
}

variable "cluster_code" {
  type        = string
  description = "cluster_code"
}

variable "app_prefix" {
  type        = string
  description = "app_prefix"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "locationcode" {
  type        = string
  description = "Location code of the resource group"
}

variable "environment" {
  type        = string
  description = "environment"
}

variable "application" {
  type        = string
  description = "application"
}

variable "rg_tags" {
  type = object({
    environment = string
    costcenter  = string
  })
  description = "tags of the resource group"
}

#################################### AKS Platform Immutable Variables Section ######################################################

variable "aks_administrators" {
  type        = string
  description = "aks_administrators"
}

variable "network_plugin" {
  type        = string
  description = "network_plugin"
}

variable "network_policy" {
  type        = string
  description = "network_policy"
}

variable "service_cidr" {
  type        = string
  description = "service_cidr"
}

variable "dns_service_ip" {
  type        = string
  description = "dns_service_ip"
}

variable "pod_cidr" {
  type        = string
  description = "pod_cidr"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "docker_bridge_cidr"
}

variable "outbound_type" {
  type        = string
  description = "outbound_type"
}

variable "load_balancer_sku" {
  type        = string
  description = "load_balancer_sku"
}

variable "dnp_name" {
  type        = string
  description = "dnp_name"
}

variable "dnp_node_count" {
  type        = string
  description = "dnp_node_count"
}

variable "dnp_vm_size" {
  type        = string
  description = "dnp_vm_size"
}

variable "dnp_type" {
  type        = string
  description = "dnp_type"
}

variable "dnp_availability_zones" {
  type        = list(any)
  description = "dnp_availability_zones"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes_version"
}

variable "orchestrator_version" {
  type        = string
  description = "orchestrator_version"
}

variable "sku_tier" {
  type        = string
  description = "sku_tier"
}

variable "private_cluster_public_fqdn_enabled" {
  type        = string
  description = "private_cluster_public_fqdn_enabled"
}

variable "aks_lp_ssh_key_data" {
  type        = string
  description = "aks_lp_ssh_key_data"
}

variable "aks_lp_admin_username" {
  type        = string
  description = "aks_lp_admin_username"
}

#################################### AKS Network Resource Variables Section ########################################################

variable "aks_vnet_rg" {
  type        = string
  description = "Virtual Network RG Name"
}

variable "aks_vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "aks_snet_name" {
  type        = string
  description = "Virtual SubNetwork Name"
}


variable "bgp_route_propagation" {
  type        = string
  description = "Status of BGP route propagation"
}

variable "route_name" {
  type        = string
  description = "Name of the route"
}

variable "address_prefix" {
  type        = string
  description = "Address Prefix"
}

variable "next_hop_type" {
  type        = string
  description = "Next hop type"
}

variable "next_hop_in_ip_address" {
  type        = string
  description = "Next hop in ip address"
}

variable "nw_name" {
  type        = string
  description = "Network Watcher Name"
}

variable "nw_rg" {
  type        = string
  description = "Network Watcher Resource Group"
}

variable "sa_nsgflowlog" {
  type        = string
  description = "NSG Flow Log Storage Account"
}

variable "sa_nsgflowlog_rg" {
  type        = string
  description = "NSG Flow Log Storage Account Resource Group"
}

#################################### Azure Platform Immutable Variables Section ####################################################
# Start variable declaration for Service Principal

variable "application_subscription_id" {
  type        = string
  description = "application_subscription_id"
}

variable "cicd_sp_client_id" {
  type        = string
  description = "cicd_sp_client_id"
}

variable "cicd_sp_client_secret" {
  type        = string
  description = "cicd_sp_client_secret"
}

variable "azure_tenant_id" {
  type        = string
  description = "azure_tenant_id"
}

variable "aks_umi_id" {
  type        = string
  description = "aks_umi_id"
}

# End variable declaration for Service Principal

# Start Hub resource variable declaration 

variable "hub_subscription_id" {
  type        = string
  description = "hub_subscription_id"
}

/*
variable "hub_aks_pdns" {
  type        = string
  description = "hub_aks_pdns"
}

variable "hub_sr_rg" {
  type        = string
  description = "hub_sr_rg"
}
*/
# End Hub resource variable declaration 

# Start Log Analytics Workspace variable declaration 

variable "law_subscription_id" {
  type        = string
  description = "law_subscription_id"
}

variable "core_law_name" {
  type        = string
  description = "core_law_name"
}

variable "core_law_rg" {
  type        = string
  description = "core_law_rg"
}

variable "diagnostics_name" {
  description = "diagnostics_name"
  type        = string
}

variable "law_name" {
  description = "LAW"
  type        = string
}
# End Log Analytics Workspace variable declaration 

