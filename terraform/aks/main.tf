resource "azurerm_resource_group" "aks_resource_group" {
  name     = "aks-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myproject-aks1"
  location            = azurerm_resource_group.aks_resource_group.location
  resource_group_name = azurerm_resource_group.aks_resource_group.name
  dns_prefix          = "myprojectaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}
