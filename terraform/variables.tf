# Azure variables
variable "subscription_id" {
  description = "The subscription ID for the Azure provider."
  type        = string
}

# Random ID for unique resource names
variable "random_id" {
  description = "A random ID that will be used to create unique names for resources."
  type        = string
  default     = ""
}

# ACR variables
variable "acr_name_prefix" {
  default = "workshopacr"
  description = "Prefix of the ACR name that be will combined with a random ID."
  type        = string
}

# AKS variables
variable "cluster_name" {
  default = "workshop-aks-demo-cluster"
  type        = string
}
variable "dns_prefix" {
  default = "workshop-aks"
  type        = string
}
variable "agent_count" {
  default = 1
}

# Azure VM variables
variable "vm_name" {
  default = "workshop-vm"
  description = "Name of the VM."
  type        = string
}
variable "vmstorage_name_prefix" {
  default = "vmhd"
  description = "Prefix of the VM storage's name that be will combined with a random ID."
  type        = string
}
variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

# Resource group variables
variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
  type        = string
}
variable "resource_group_name_prefix" {
  default     = "workshop-demo-rg"
  description = "Prefix of the resource group names that will be combined with a random ID."
  type        = string
}
