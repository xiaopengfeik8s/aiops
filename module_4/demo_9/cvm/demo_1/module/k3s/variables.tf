variable "password" {
  default = "password123"
}

variable "public_ip" {
  default = ""
}

variable "private_ip" {
  default = ""
}

variable "user" {
  default = "ubuntu"
}

variable "server_name" {
  default = "k3s"
}

variable "pods_cidr" {
  default = "10.42.0.0/16"
}

variable "service_cidr" {
  default = "10.43.0.0/16"
}
