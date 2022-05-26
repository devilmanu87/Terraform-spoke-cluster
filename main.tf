########################################################################################################################################################################
######################################################## Download the AKS Terraform Template code ######################################################################
########################################################################################################################################################################

module "tf_aks_repo" {
  #source           = "git::https://azgithub.ops.crd.com/CPE-Terraform/trf-az-aks.git?ref=master"
  source           = "git::https://azgithub.ops.crd.com/Alpha-Grid-Platform-Engineering/trf-agrid-az-aks.git"
} 

# Get variable defintions from default
module "platform_prop" {
  source                 = "./platform-tf-defaults/trf-region-specific"
  region                 = var.location
}


########################################################################################################################################################################
########################################## Loading required Azure Resources as Data Reference ##########################################################################
########################################################################################################################################################################

# Data Section

data "azurerm_virtual_network" "vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.aks_vnet_rg
}

data "azurerm_subnet" "aks_snet" {
  name                 = var.aks_snet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

# Get AKS Administer Group

data "azuread_group" "aks_administrators" {
  display_name = var.aks_administrators
}

# Get Hub K8S Private DNS Zone data

data "azurerm_private_dns_zone" "akspdns" {
  provider            = azurerm.hub
  name                = module.platform_prop.s.aks_pdns.hub_aks_pdns
  resource_group_name = module.platform_prop.s.aks_pdns.hub_sr_rg
  #name                = var.hub_aks_pdns
  #resource_group_name = var.hub_sr_rg
}

# Get Core LAW data

data "azurerm_log_analytics_workspace" "law" {
  provider            = azurerm.law
  name                = var.core_law_name
  resource_group_name = var.core_law_rg
}

# Get Hub LAW NSG Flow log SA data

data "azurerm_storage_account" "lawnsgflsa" {
  provider            = azurerm.hub
  name                = var.sa_nsgflowlog
  resource_group_name = var.sa_nsgflowlog_rg
}

# Get Network Watcher data

data "azurerm_network_watcher" "nw" {
  name                = var.nw_name
  resource_group_name = var.nw_rg
}

########################################################################################################################################################################
########################################## Local Variables tobe used for new Azure Resources ###########################################################################
########################################################################################################################################################################

locals {
  resourcegroup      = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-rg-${var.cluster_code}"
  routetable         = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-rt-aks-${var.cluster_code}"
  route              = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-udr-${var.route_name}"
  nsgname            = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-nsg-aks-${var.cluster_code}"
  lawname            = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-law-${var.core_law_name}"
  aksclustername     = "${var.app_prefix}-${var.locationcode}-${var.environment}-${var.application}-aks-${var.cluster_code}"
}


########################################################################################################################################################################
########################################## Creating all dependent Azure resources before creating AKS Cluster ##########################################################
########################################################################################################################################################################

# Create Resource Group

resource "azurerm_resource_group" "rg" {
  name     = local.resourcegroup
  location = var.location
  tags     = var.rg_tags
}

# Create Route Table

module "rt" {
  source   = "./.terraform/modules/tf_aks_repo/azure-routetable"
  #source   = "./terraform-modules/azure-routetable"
  rt_name  = local.routetable
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  rg_tags  = var.rg_tags
  bgp_route_propagation = var.bgp_route_propagation
}

# Create Route 

module "routes" {
  source                 = "./.terraform/modules/tf_aks_repo/azure-routes"
  #source                 = "./terraform-modules/azure-routes"
  route_name             = local.route
  rt_name                = module.rt.rt_name
  rg_name                = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  address_prefix         = var.address_prefix
  next_hop_type          = var.next_hop_type
  next_hop_in_ip_address = var.next_hop_in_ip_address
}

# Create Network Security Group

module "nsg" {
  source   = "./.terraform/modules/tf_aks_repo/azure-nsg"
  #source   = "./terraform-modules/azure-nsg"
  nsg_name = local.nsgname
  rg_name  = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

# Associate AKS Subnet with Route table

module "snetrtasso" {
  source  = "./.terraform/modules/tf_aks_repo/azure-snet-rt-asso"
  #source  = "./terraform-modules/azure-snet-rt-asso"
  rt_id   = module.rt.rt_id
  snet_id = data.azurerm_subnet.aks_snet.id
}

# Associate AKS Subnet with Network Security Group

module "snetnsgasso" {
  source  = "./.terraform/modules/tf_aks_repo/azure-snet-nsg-asso"
  #source  = "./terraform-modules/azure-snet-nsg-asso"
  nsg_id  = module.nsg.nsg_id
  snet_id = data.azurerm_subnet.aks_snet.id
}

# Create Network Watcher NSG Flow Log

module "nwnsgfl" {
  source                = "./.terraform/modules/tf_aks_repo/azure-nsg-flowlog"
  #source                = "./terraform-modules/azure-nsg-flowlog"
  nw_name               = var.nw_name
  nw_rg                 = var.nw_rg
  nsg_id                = module.nsg.nsg_id
  sa_id                 = data.azurerm_storage_account.lawnsgflsa.id
  workspace_id          = data.azurerm_log_analytics_workspace.law.workspace_id
  workspace_region      = azurerm_resource_group.rg.location
  workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
}

########################################################################################################################################################################
########################################## Creating new AKS Cluster with Default system nodepool #######################################################################
########### Note: Use this repo to create the new additional user node pools for any AKS cluster #######################################################################
########################################################################################################################################################################


# Create AKS Cluster

module "aks" {
  source                     = "./.terraform/modules/tf_aks_repo/azure-aks"
  #source                     = "./terraform-modules/azure-aks"
  utility_cluster_name       = local.aksclustername
  kubernetes_version         = var.kubernetes_version
  orchestrator_version       = var.orchestrator_version  
  sku_tier                   = var.sku_tier
  pvt_public_fdqn_enable     = var.private_cluster_public_fqdn_enabled
  rg_name                    = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  snet_id                    = data.azurerm_subnet.aks_snet.id
  akspdns_id                 = data.azurerm_private_dns_zone.akspdns.id
  aks_administrators_ids     = [data.azuread_group.aks_administrators.id]
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id
  network_plugin             = var.network_plugin
  network_policy             = var.network_policy
  service_cidr               = var.service_cidr
  dns_service_ip             = var.dns_service_ip
  dns_prefix                 = var.dns_prefix
  pod_cidr                   = var.pod_cidr
  docker_bridge_cidr         = var.docker_bridge_cidr
  outbound_type              = var.outbound_type
  load_balancer_sku          = var.load_balancer_sku
  dnp_name                   = var.dnp_name
  dnp_node_count             = var.dnp_node_count
  dnp_vm_size                = var.dnp_vm_size
  dnp_type                   = var.dnp_type
  dnp_availability_zones     = var.dnp_availability_zones
  aks_umi_id                 = var.aks_umi_id
  #aks_sp_client_id           = var.aks_sp_client_id
  #aks_sp_client_secret       = var.aks_sp_client_secret
  aks_lp_admin_username      = var.aks_lp_admin_username
  aks_lp_ssh_key_data        = var.aks_lp_ssh_key_data

  diagnostics_name           = var.diagnostics_name
  law_name                   = var.law_name

  #depends_on                 = [module.snetrtasso]
}

# Create AKS Cluster User Pool

#userPools:
#cpSvcPool
# - kafka(22 pod in QA) - 12nodes(9broker,3zookeeper,1client=10)
#tenantSvcPool(open to all services for which the tolerations cannot be defined as of now)
# - ibor, datapipe, alpha portal, nginx/ambasaddor
#GeneralSvcPool
# - argocd, tracing, fleuntd, prometheous, litmus/chaos
#prometheus/MetricPool
# - prometheus, grafana

/*

module "aks_cpsvc_pool" {
  source                  = "./terraform-modules/azure-aks-userpool-notaints"
  unp_name                = "cpsvc"
  rg_name                 = azurerm_resource_group.rg.name
  snet_id                 = data.azurerm_subnet.aks_snet.id
  aks_id                  = module.aks.aks_id
  unp_vm_size             = "Standard_D8s_v4"
  unp_node_count          = 18
  unp_node_labels         = { app_pool = "cpsvc" }
  unp_availability_zones  = [1, 2, 3]
}

module "aks_generalsvc_pool" {
  source                  = "./terraform-modules/azure-aks-userpool"
  unp_name                = "generalsvc"
  rg_name                 = azurerm_resource_group.rg.name
  snet_id                 = data.azurerm_subnet.aks_snet.id
  aks_id                  = module.aks.aks_id
  unp_vm_size             = "Standard_D8s_v4"
  unp_node_count          = 3
  unp_node_labels         = { app_pool = "generalsvc" }
  unp_node_taints         = ["sku=generalsvc:NoSchedule"]
  unp_availability_zones  = [1, 2, 3]
}


module "aks_tenantsvc_pool" {
  source                  = "./terraform-modules/azure-aks-userpool-notaints"
  unp_name                = "tenantsvc"
  rg_name                 = azurerm_resource_group.rg.name
  snet_id                 = data.azurerm_subnet.aks_snet.id
  aks_id                  = module.aks.aks_id
  unp_vm_size             = "Standard_D64s_v4"
  unp_node_count          = 6
  unp_node_labels         = { app_pool = "tenantsvc" }  
  unp_availability_zones  = [1, 2, 3]
}

module "aks_metricssvc_pool" {
  source                  = "./terraform-modules/azure-aks-userpool"
  unp_name                = "metricssvc"
  rg_name                 = azurerm_resource_group.rg.name
  snet_id                 = data.azurerm_subnet.aks_snet.id
  aks_id                  = module.aks.aks_id
  unp_vm_size             = "Standard_D16s_v4"
  unp_node_count          = 6
  unp_node_labels         = { app_pool = "metricssvc" }
  unp_node_taints         = ["sku=metricssvc:NoSchedule"]
  unp_availability_zones  = [1, 2, 3]
}

*/
