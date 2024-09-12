output "kube_config" {
  value = module.k3s.kube_config
}

output "kubernetes" {
  value = module.k3s.kubernetes
}