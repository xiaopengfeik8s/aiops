output "public_ip" {
  description = "The public ip of instance."
  value       = tencentcloud_instance.ubuntu.public_ip
}

output "private_ip" {
  description = "The private ip of instance."
  value       = tencentcloud_instance.ubuntu.private_ip
}

output "ssh_password" {
  description = "The SSH password of instance."
  value       = var.password
}
