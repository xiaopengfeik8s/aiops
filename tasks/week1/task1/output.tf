output "public_ip" {
  description = "vm public ip address"
  value       = alicloud_instance.instance.public_ip
}

