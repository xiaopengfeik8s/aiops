provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

resource "helm_release" "app" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.namespace
  create_namespace = true
}