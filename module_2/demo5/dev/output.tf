output "how_to_get_argocd_user_and_password" {
    description = "export KUBECONFIG=path/config.yaml"
  value = "Default user is 'admin' and to exec  'kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d' to get the password."
}

output "how_to_visit_argocd" {
    value = "Excute the command `kubectl port-forward svc/argocd-server -n argocd 8080:80 --address 0.0.0.0` , and visit the url 'http://localhost:8080' via browser."
}