resource "azurerm_role_assignment" "ara" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azure_kubernetes_cluster.aks.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_subnet" "example" {
  name                 = var.subnetname
  resource_group_name  = var.rgname
  virtual_network_name = var.vnetname
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = []

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

10.135.0.36 to be added to VNet dns

Service endpoint for pep subnet ACR, KV, SA, Service Bus

NSG Storage Account create
Enable NSG Flow in NSG

# AZCLI - AKV Provisioning Script
## Update Subnet to enable Microsoft.KeyVault service endpoint
az network vnet subnet update -n qa-aks-subnet-001 --service-endpoints Microsoft.KeyVault --subscription alpha-eng-sbx --vnet-name alphaeng-vnet-001-dev-eastus -g alphaeng-rg-net-001-dev-eastus

az aks create 
--subscription b62b39b7-71df-44f0-a7fe-ae78cf18c2b8 \
--resource-group alphaf2b-eastus-np-rg-aks-001 \
--name alpha-f2b-aks-np-001 \
--node-count 1 \
--network-plugin kubenet \
--network-policy calico \
--service-cidr 172.20.0.0/16 \
--dns-service-ip 172.20.0.10 \
--pod-cidr 172.22.0.0/16 \
--docker-bridge-address 172.21.0.1/16 \
--vnet-subnet-id /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaf2b-eastus-np-rg-aks-001/providers/Microsoft.Network/virtualNetworks/alphaf2b-eastus-np-vnet-aks-001/subnets/alphaf2b-eastus-np-snet-aks-001 \
--service-principal f68fb7dd-b62c-4f4d-b8e7-8ba35de67bef \
--client-secret crP@dC=yq_cM/HfgbGRQxAfJGyL6v598 \
--generate-ssh-keys \
--outbound-type userDefinedRouting \
--load-balancer-sku standard \
--node-vm-size Standard_D8s_v3 \
--enable-private-cluster \
--vm-set-type VirtualMachineScaleSets \
--enable-addons azure-policy \
--zones 1 2 3

az aks create 
--subscription b62b39b7-71df-44f0-a7fe-ae78cf18c2b8 \
--resource-group alphaf2b-eastus-np-rg-aks-001 \
--name alpha-f2b-aks-np-001 \
--node-count 1 \
--network-plugin kubenet \
--network-policy calico \
--service-cidr 172.20.0.0/16 \
--dns-service-ip 172.20.0.10 \
--pod-cidr 172.22.0.0/16 \
--docker-bridge-address 172.21.0.1/16 \
--vnet-subnet-id /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaf2b-eastus-np-rg-aks-001/providers/Microsoft.Network/virtualNetworks/alphaf2b-eastus-np-vnet-aks-001/subnets/alphaf2b-eastus-np-snet-aks-001 \
--service-principal f68fb7dd-b62c-4f4d-b8e7-8ba35de67bef \
--client-secret crP@dC=yq_cM/HfgbGRQxAfJGyL6v598 \
--generate-ssh-keys \
--outbound-type userDefinedRouting \
--load-balancer-sku standard \
--node-vm-size Standard_D8s_v3 \
--enable-private-cluster \
--vm-set-type VirtualMachineScaleSets \
--enable-addons azure-policy \
--zones 1 2 3

az keyvault create 
      -g alphaeng-qa-rg-001-dev-eastus 
      -n alphaf2b-qa-ibor-kv-001 
      --default-action deny  
      --enable-soft-delete true 
      --enabled-for-deployment false 
      --enabled-for-disk-encryption false 
      --enabled-for-template-deployment false 
      -l eastus 
      --no-self-perms 
      --sku standard 
      --subscription alpha-eng-sbx 
      --network-acls-vnets /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaeng-rg-net-001-dev-eastus/providers/Microsoft.Network/virtualNetworks/alphaeng-vnet-001-dev-eastus/subnets/qa-aks-subnet-001 
      --network-acls-ips 50.201.19.35/32

az network private-endpoint create 
    --name alpha-akv-qa-pvtep-01 
    -g alphaeng-qa-rg-001-dev-eastus 
    --subnet /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaeng-rg-net-001-dev-eastus/providers/Microsoft.Network/virtualNetworks/alphaeng-vnet-001-dev-eastus/subnets/alpha-pvt-ep-eastus-001 
    --private-connection-resource-id /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaeng-qa-rg-001-dev-eastus/providers/Microsoft.KeyVault/vaults/alphaf2b-qa-ibor-kv-001 
    --group-id vault 
    --connection-name akv-qa-pvt-ep-connection-001 
    --subscription alpha-eng-sbx
    

az network private-dns record-set a create 
    --name alphaf2b-qa-ibor-kv-001 
    --zone-name privatelink.vaultcore.azure.net 
    -g it-rg-ntw-001-int-eastus 
    --subscription crd-eng-hub
 
az network private-dns record-set a add-record 
    --record-set-name alphaf2b-qa-ibor-kv-001 
    --zone-name privatelink.vaultcore.azure.net 
    -g it-rg-ntw-001-int-eastus 
    --subscription crd-eng-hub 
    --ipv4-address 10.135.4.120

/*
# Create Network Security Group Rules

module "nsgrule" {
  source                     = "./terraform-modules/azure-nsg-rule"
  nsg_rule_name              = "Test-Allow"
  rg_name                    = azurerm_resource_group.rg.name
  nsg_name                   = module.nsg.nsg_name
  priority                   = "1000"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "10.10.0.0/16"
  destination_address_prefix = "*"
}


module "nsgrule2" {
  source                     = "./terraform-modules/azure-nsg-rule"
  nsg_rule_name              = "Test-Allow2"
  rg_name                    = azurerm_resource_group.rg.name
  nsg_name                   = module.nsg.nsg_name
  priority                   = "1000"
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "10.20.0.0/16"
  destination_address_prefix = "*"
}
*/

az aks create 
--subscription b62b39b7-71df-44f0-a7fe-ae78cf18c2b8 
--resource-group alphaeng-qa-rg-001-dev-eastus 
--name alpha-f2b-aks-qa-001 
--node-count 1
--network-plugin kubenet 
--network-policy calico 
--service-cidr 172.20.0.0/16 
--dns-service-ip 172.20.0.10 
--pod-cidr 172.22.0.0/16 
--docker-bridge-address 172.21.0.1/16 
--vnet-subnet-id /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaeng-rg-net-001-dev-eastus/providers/Microsoft.Network/virtualNetworks/alphaeng-vnet-001-dev-eastus/subnets/qa-aks-subnet-001 
--service-principal f68fb7dd-b62c-4f4d-b8e7-8ba35de67bef 
--client-secret <masked for security reasons> 
--generate-ssh-keys 
--outbound-type userDefinedRouting 
--load-balancer-sku standard 
--node-vm-size Standard_D8s_v3 
--enable-private-cluster 
--vm-set-type VirtualMachineScaleSets 
--enable-addons azure-policy 
--zones 1 2 3

network-plugin kubenet 
network-policy calico 
service-cidr 172.20.0.0/16 
dns-service-ip 172.20.0.10 
pod-cidr 172.22.0.0/16 
docker-bridge-address 172.21.0.1/16 

NSG Rules:
az network nsg rule create 
--name crd-from-onprem-network-allow 
--nsg-name alphaeng-nsg-aks-01-dev-eastus 
--priority 1000 
--resource-group alphaeng-rg-net-001-dev-eastus 
--access Allow 
--destination-address-prefixes * 
--destination-port-ranges 443       
--direction Inbound 
--protocol Tcp 
--source-address-prefixes 10.10.0.0/16 
--source-port-ranges * 
--subscription alpha-eng-sbx


az network nsg rule create 
--name crd-to-onprem-network-allow 
--nsg-name alphaeng-nsg-aks-01-dev-eastus 
--priority 1000 
--resource-group alphaeng-rg-net-001-dev-eastus 
--access Allow --destination-address-prefixes 10.20.0.0/16 
--destination-port-ranges 443 
--direction Outbound 
--protocol Tcp --source-address-prefixes * 
--source-port-ranges * 
--subscription alpha-eng-sbx
NSG Flow Logs:

az network watcher flow-log configure --nsg alphaeng-nsg-aks-01-dev-eastus -g alphaeng-rg-net-001-dev-eastus --enabled true --format JSON --interval 30 --retention 90 --log-version 2 --storage-account /subscriptions/b62b39b7-71df-44f0-a7fe-ae78cf18c2b8/resourceGroups/alphaeng-rg-net-001-dev-eastus/providers/Microsoft.Storage/storageAccounts/alphasadev001 --workspace /subscriptions/3dc6e706-990f-4ae7-9e84-f23d847c948b/resourcegroups/it-rg-law-001-int-eastus/providers/microsoft.operationalinsights/workspaces/it-law-hub-001-int-eastus --traffic-analytics true
