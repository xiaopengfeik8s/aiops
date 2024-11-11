output "kube_config" {
  value = module.k3s.kube_config
}

output "kubernetes_ready" {
  value = module.k3s.kubernetes_ready
}

output "summary" {
  value = module.k3s.summary
}
