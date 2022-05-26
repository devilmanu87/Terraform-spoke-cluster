output "rg_id" {
  value = azurerm_resource_group.rg.id
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "rt_id" {
  value = module.rt.rt_id
}

output "rt_name" {
  value = module.rt.rt_name
}

output "route_id" {
  value = module.routes.route_id
}

output "route_name" {
  value = module.routes.route_name
}

output "nsg_id" {
  value = module.nsg.nsg_id
}

output "nsg_name" {
  value = module.nsg.nsg_name
}

output "nw_id" {
  value = data.azurerm_network_watcher.nw.id
}

output "law_id" {
  value = data.azurerm_log_analytics_workspace.law.workspace_id
}

output "law_resource_id" {
  value = data.azurerm_log_analytics_workspace.law.id
}

#output "spn_vault_uri" {
#  value = data.azurerm_key_vault.spnkv.vault_uri
#}

# output "spn_aks_secret_value" {
#   value = data.azurerm_key_vault_secret.spnkvakssecret.value
# }

# output "snet_id" {
#   value = module.snet.snet_id
# }

# output "snet_name" {
#   value = module.snet.snet_name
# }
