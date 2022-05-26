####################################################################################################################################
#################################### AKS Cluster input Variables Section ###########################################################
###### Note: Pay attention to these variables,these will be used to decided the AKS resources naming convention ####################
####################################################################################################################################
#AKS Cluster
dns_prefix = "agrid-spoke1"

# AKS Variables
cluster_code = "001"

# Product Prefix
app_prefix = "agrid"

# Resource Locations
location = "eastus"

# Resource Location code
locationcode = "01"

# Environment
environment = "d1"

# Application
application = "spoke1"

# Resource Group Variables
#rg_name = "001"
rg_tags = {
  CloudServiceType       = "Hub"
  CustomerId             = "agrid01d1"
  DataClassification     = "Confidential"
  ApplicationName        = "AGRID"
  ApplicationService     = "SpokeCluster"
  ApplicationVersion     = "1.4"
  ApplicationEnvironment = "np"
  createdOn              = "8/11/2021"
  expiredOn              = "12/31/2025"
  environment            = "nonprod"
  costcenter             = "agrid"
}

#VirtualNetowrk Details
aks_vnet_rg = "agrid-01-d1-spk-crd-rg-001"
aks_vnet_name = "agrid-01-d1-spk-crd-vnet-001"
aks_snet_name = "agrid-01-d1-snet-aks-001"
application_subscription_id = "4cdde026-a1dc-48ef-98be-b48892c3f96d"

# AKS default system pool count
dnp_node_count         = 3

#Application Firewall IP
next_hop_in_ip_address = "10.61.0.4"

# Storage Account for NSG flow logs
sa_nsgflowlog    = "agrid01d1util01"
sa_nsgflowlog_rg = "agrid-01-d1-hub-storage-rg-001"

####################################################################################################################################
#################################### AKS Platform Immutable Variables Section ######################################################
########## Note: No changes required to the vairables under this section, unless directed by CPE Team ##############################
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
#"1.19.11" - current
#"1.20.15" - interim
#"1.21.9"  - desired
kubernetes_version     = "1.21.9"
orchestrator_version   = "1.21.9"

sku_tier = "Paid"
private_cluster_public_fqdn_enabled = "false"

#AKS SSH Key Details
## Linux Profile Key
#aks_lp_ssh_key_data   = "ssh-rsa ***" #Value supplied as ENV variables before running Terraform
aks_lp_ssh_key_data   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClCWu2xnroEOSpB/4SxW5LaFuDUDl3sr2uvoxNIaaaN808lZWJeK3ikpPxcW85w1lIVNQH282PLh0z7lVnubo0TPtB2q+9CjrmiNaAOsI23yp9dmhmgyW9qwxZ/qMBemD+IT53p4al35xcZGM+OoxPv30LG251pf1Jofacbf+aGBXGD9PW7Yd1/DXSJ64gcKhg8mEQSB3w4Q5XidTkvNdsmp6ACFmlU/N73d/I1p0Ujph65jawvVzrrnZZ5yyEg7TMOXJI5s2TkceFGii8F0SuyqI+nL1+j/Kie4HyV/D/VUdTz+qUGo135wUxSpQ4vH6hrBPSA1nWwFVGYIQSv+kl"
aks_lp_admin_username = "azureuser"

####################################################################################################################################
#################################### AKS Network Resource Variables Section ########################################################
########## Note: No changes required to the vairables under this section, unless directed by CPE Team ##############################
####################################################################################################################################
# Route Table Variables
bgp_route_propagation = "true"

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
########## Note: No changes required to the vairables under this section, unless directed by CPE Team ##############################
####################################################################################################################################
azure_tenant_id     = "f7d9f3f1-3841-4bfc-9cd4-c0e1964b5f86"

# CI/CD SP Credentials
# cicd_sp_display_name    = "agrid-cpe-d1-aks-rw-cicd-spn-01"
cicd_sp_client_id     = "f9fc4ebb-0b04-4820-8f04-f6f9f590e054"
cicd_sp_client_secret = "ABbK-NDJ-****************"
#cicd_sp_client_secret = "" #Value supplied as ENV variables before running Terraform


# AKS Credentials - using SPN
#aks_sp_display_name    = "agrid-cpe-d1-aks-admin-cluster-spn-01"
#aks_sp_client_id     = "75322d39-9786-4b12-8e31-abf06449c85b"
#aks_sp_client_secret = "" #Value supplied as ENV variables before running Terraform

# AKS Credentials - using UMI
aks_umi_id = "/subscriptions/4cdde026-a1dc-48ef-98be-b48892c3f96d/resourceGroups/agrid-01-d1-spk-crd-rg-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/agrid-01-d1-spk-aks-umi-001"

# Hub Subscription Variables
#SubscriptionName: agrid-01-d1-hub-sub-001
hub_subscription_id = "a786eb34-3c9e-4875-a35b-d91487d59d5c"

# Law Subscription
#law-01-p1-hub-sub-001
law_subscription_id = "3ee16415-b4d5-4e55-af45-6ab5d8bf5a71"
core_law_name       = "core-01-p0-law-000"
core_law_rg         = "core-01-p0-sr-law-rg-001"

law_name                = "/subscriptions/3ee16415-b4d5-4e55-af45-6ab5d8bf5a71/resourcegroups/core-01-p0-sr-law-rg-001/providers/microsoft.operationalinsights/workspaces/core-01-p0-law-000"
diagnostics_name        = "service"
