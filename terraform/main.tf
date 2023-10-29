# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "aks" {
  source = "./aks"
}

data "azurerm_kubernetes_cluster" "aks" {
  depends_on          = [module.aks] # refresh cluster state before reading
  name                = "myproject-aks1"
  resource_group_name = "aks-resources"
}

provider "kubernetes" {
  host                   = "${data.azurerm_kubernetes_cluster.aks.kube_config.0.host}"
  client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}
