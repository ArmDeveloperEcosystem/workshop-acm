output "aks_resource_group_name" {
  value = azurerm_resource_group.aksrg.name
}

output "vm_resource_group_name" {
  value = azurerm_resource_group.vmrg.name
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw

  sensitive = true
}