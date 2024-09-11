provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

resource "helm_release" "argo_cd" {
  depends_on       = [module.k3s]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}