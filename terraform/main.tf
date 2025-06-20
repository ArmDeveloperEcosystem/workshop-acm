# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
}

locals {
  resource_group_name = var.random_id != "" ? "${var.resource_group_name_prefix}-${var.random_id}" : random_pet.rg_name.id
}

resource "azurerm_resource_group" "aksrg" {
  location = "${var.resource_group_location}-aks"
  name     = local.resource_group_name
}

resource "azurerm_resource_group" "vmrg" {
  location = "${var.resource_group_location}-vm"
  name     = local.resource_group_name
}