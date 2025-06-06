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
  default = "armacr"
  description = "Prefix of the ACR name that be will combined with a random ID."
  type        = string
}

# AKS variables
variable "cluster_name" {
  default = "arm-aks-demo-cluster"
  type        = string
}
variable "dns_prefix" {
  default = "arm-aks"
  type        = string
}
variable "agent_count" {
  default = 2
}

# Resource group variables
variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
  type        = string
}
variable "resource_group_name_prefix" {
  default     = "arm-aks-demo-rg"
  description = "Prefix of the resource group name that will be combined with a random ID."
  type        = string
}