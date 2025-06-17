# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false
}

locals {
  resource_group_name = var.random_id != "" ? "${var.resource_group_name_prefix}-${var.random_id}" : random_pet.rg_name.id
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = local.resource_group_name
}
