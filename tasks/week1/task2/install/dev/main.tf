module "ecs" {
  source     = "../modules/ecs"
  secret_id  = var.secret_id
  secret_key = var.secret_key
}

module "k3s" {
  source     = "../modules/k3s"
  public_ip  = module.ecs.public_ip
  private_ip = module.ecs.private_ip
}


module "argocd" {
  source     = "../modules/helm"
  kube_config = local_sensitive_file.kubeconfig.filename
  name = "argocd"
  namespace = "argocd"
  chart = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"

}



module "crossplane" {
  source     = "../modules/helm"
  kube_config = local_sensitive_file.kubeconfig.filename
  name = "crossplane"
  namespace = "crossplane-system"
  chart = "crossplane"
  repository = "https://charts.crossplane.io/stable"

}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kube_config
  filename = "${path.module}/config.yaml"
}