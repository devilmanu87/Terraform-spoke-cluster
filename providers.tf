# Azure Resource Manager and Azure Active Directory Terraform Providers are required

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.73.0"
      #version = "2.79.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "agrid-01-d1-hub-storage-rg-001"
    storage_account_name = "agrid01d1util01"
    tenant_id            = "f7d9f3f1-3841-4bfc-9cd4-c0e1964b5f86"
    subscription_id      = "a786eb34-3c9e-4875-a35b-d91487d59d5c"
    access_key           = "3IUi49LYqIPLHSzMEuGJsXLDR2mK6FaO81klg0INQec68YaWAzWqspltuoiF4UkyasF5cU59hLsbiDXtzcwgYA=="
  }

}

########################################################################################################################################################################
########################################## This section is to get the Terraform provider ###############################################################################
########################################################################################################################################################################

# Azure Active Directory Provider
provider "azuread" {

}

# Azure Resource Manager Provider for AGRID Spoke

provider "azurerm" {
  features {}

  subscription_id = var.application_subscription_id
  client_id       = var.cicd_sp_client_id
  client_secret   = var.cicd_sp_client_secret #This set as ENV value
  tenant_id       = var.azure_tenant_id

}

# Azure Resource Manager Provider for AGRID Hub

provider "azurerm" {
  features {}
  alias = "hub"

  subscription_id = var.hub_subscription_id
  client_id       = var.cicd_sp_client_id
  client_secret   = var.cicd_sp_client_secret #This set as ENV value
  tenant_id       = var.azure_tenant_id

}

# Azure Resource Manager Provider for CRD Log Analytics Workspace

provider "azurerm" {
  features {}
  alias = "law"

  subscription_id            = var.law_subscription_id
  client_id                  = var.cicd_sp_client_id
  client_secret              = var.cicd_sp_client_secret
  tenant_id                  = var.azure_tenant_id
  skip_provider_registration = true
}
