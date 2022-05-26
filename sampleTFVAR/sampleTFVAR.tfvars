####################################################################################################################################
#################################### AKS Cluster input Variables Section ###########################################################
###### Note: Pay attention to these variables,these will be used to decided the AKS resources naming convention ####################
####################################################################################################################################
#AKS Cluster
dns_prefix = "ihub-spoke2"

# AKS Variables
cluster_code = "001"

# Product Prefix
app_prefix = "ihub"

# Resource Locations
location = "eastus2"

# Resource Location code
locationcode = "06"

# Environment
environment = "d1"

# Application
application = "spoke2"

# Resource Group Variables
rg_tags = {
  CloudServiceType       = "Hub"
  CustomerId             = "ihub06d0"
  DataClassification     = "Confidential"
  ApplicationName        = "IHub"
  ApplicationService     = "SpokeCluster"
  ApplicationVersion     = "1.4"
  ApplicationEnvironment = "uat"
  createdOn              = "9/29/2021"
  expiredOn              = "12/31/2025"
  environment            = "uat"
  costcenter             = "agrid"
}

#VirtualNetwork Details
aks_vnet_rg = "ihub-06-d1-spk-rg-001"
aks_vnet_name = "ihub-06-d1-spk-vnet-001"
aks_snet_name = "ihub-06-d1-snet-aks-001"
application_subscription_id = "df758666-6153-4558-9eb8-1b76b98d8d3e"

# AKS default system pool count
dnp_node_count         = 1

#Application Firewall IP
next_hop_in_ip_address = "10.124.12.4"

# Storage Account for NSG flow logs
sa_nsgflowlog    = "ihub06d1util01"
sa_nsgflowlog_rg = "ihub-06-d1-hub-storage-rg-001"

####################################################################################################################################
#################################### AKS Platform Immutable Variables Section ######################################################
########## Note: No changes required to the variables under this section, unless directed by CPE Team ##############################
####################################################################################################################################
# AAD Group Name for K8s Cluster Admin
aks_administrators = "CRDOPS-AGRID-CPE-D1-AKS-CLUSTER-Owner"

# AKS Networking Config
network_plugin     = "kubenet"
network_policy     = "calico"
service_cidr       = "172.20.0.0/16"
dns_service_ip     = "172.20.0.10"
pod_cidr           = "172.16.0.0/14"
docker_bridge_cidr = "172.21.0.1/16"
outbound_type      = "userDefinedRouting"
load_balancer_sku  = "standard"

# AKS deefault system pool
dnp_name               = "default"
dnp_vm_size            = "Standard_D4s_v4"
dnp_type               = "VirtualMachineScaleSets"
dnp_availability_zones = [1, 2, 3]

# AKS Account Tier Paid/Free
kubernetes_version = "1.19.11"
sku_tier = "Paid"
private_cluster_public_fqdn_enabled = "false"

#AKS SSH Key Details
## Linux Profile Key
aks_lp_ssh_key_data   = "" #Value supplied as ENV variables before running Terraform
aks_lp_admin_username = "azureuser"

####################################################################################################################################
#################################### AKS Network Resource Variables Section ########################################################
########## Note: No changes required to the variables under this section, unless directed by CPE Team ##############################
####################################################################################################################################
# Route Table Variables

# Routes Variables
route_name             = "aks-001"
address_prefix         = "0.0.0.0/0"
next_hop_type          = "VirtualAppliance"

# Network Security Group Variables

# Network Watcher Variables
nw_name = "NetworkWatcher_eastus"
nw_rg   = "NetworkWatcherRG"

####################################################################################################################################
#################################### Azure Platform Immutable Variables Section ####################################################
########## Note: No changes required to the variables under this section, unless directed by CPE Team ##############################
####################################################################################################################################
azure_tenant_id     = "f7d9f3f1-3841-4bfc-9cd4-c0e1964b5f86"

# CI/CD SP Credentials
# cicd_sp_display_name    = "agrid-cpe-d1-aks-rw-cicd-spn-01"
cicd_sp_client_id     = "f9fc4ebb-0b04-4820-8f04-f6f9f590e054"
cicd_sp_client_secret = "" #Value supplied as ENV variables before running Terraform

# AKS Credentials
#aks_sp_display_name    = "agrid-cpe-d1-aks-admin-cluster-spn-01"
aks_sp_client_id     = "75322d39-9786-4b12-8e31-abf06449c85b"
aks_sp_client_secret = "" #Value supplied as ENV variables before running Terraform


# Hub Subscription Variables
#SubscriptionName: ihub-01-d0-spk-sub-001
hub_subscription_id = "a786eb34-3c9e-4875-a35b-d91487d59d5c"

#Enable this for Eastus2
#hub_sr_rg           = "agrid-06-d1-hub-sr-rg-001"
#hub_aks_pdns        = "privatelink.eastus2.azmk8s.io"

#Enable this for Eastus
#hub_sr_rg           = "agrid-01-d1-hub-sr-rg-001"
#hub_aks_pdns        = "privatelink.eastus.azmk8s.io"

# Law Subscription
#law-01-p1-hub-sub-001
law_subscription_id = "3ee16415-b4d5-4e55-af45-6ab5d8bf5a71"
core_law_name       = "core-01-p0-law-000"
core_law_rg         = "core-01-p0-sr-law-rg-001"
