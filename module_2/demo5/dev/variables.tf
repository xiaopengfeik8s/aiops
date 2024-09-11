variable "private_key" {
  default = "`cat  ~/.ssh/id_rsa`"
}

variable "public_ip" {}

variable "private_ip" {}

variable "secret_id" {
  default = "Your Access ID"
}

variable "secret_key" {
  default = "Your Access Key"
}


variable "public_key" {
  default = "`cat ~/.ssh/id_rsa.pub`"
}

variable "kube_config" {}
