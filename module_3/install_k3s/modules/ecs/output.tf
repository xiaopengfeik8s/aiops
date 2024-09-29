output "public_ip" {
  description = "vm public ip address"
  value       = alicloud_instance.instance.public_ip
}

output "private_ip" {
  description = "vm private ip address"
  value       = alicloud_instance.instance.private_ip
}