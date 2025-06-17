
resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Demo"
  }
  default_node_pool {
    name       = "armpool"
    vm_size    = "Standard_D8ps_v6"
    node_count = var.agent_count
    os_disk_size_gb = 64
    temporary_name_for_rotation = "armpooltemp"

  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "amdcluster" {
  name                  = "amdpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_D2as_v5"
  node_count            = var.agent_count
  temporary_name_for_rotation = "amdpooltemp"

  tags = {
    Environment = "Demo"
  }
}