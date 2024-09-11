module "ecs" {
  source     = "../modules/ecs"
  secret_id  = var.secret_id
  secret_key = var.secret_key
  public_key = var.public_key
}

module "k3s" {
  source     = "../modules/k3s"
  public_ip  = module.ecs.public_ip
  private_ip = module.ecs.private_ip
  private_key = var.private_key
}


module "argocd" {
  source     = "../modules/argocd"
  kube_config  = var.kube_config
}
