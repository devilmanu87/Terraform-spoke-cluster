variable "region" {
  type = string
}

locals {
  type_map = {
    "eastus"                       = local.eastus
    "eastus2"                      = local.eastus2
  }
}

output "s" {
  value = lookup(local.type_map, format("%s", var.region), "unknown")
}
