terraform {
  required_providers {
    alicloud = {
      # 在使用 module 时，我们强烈推荐使用 hashicorp 源。aliyun 源的 provider 无法被 module 继承，可能会导致部分配置不生效
      source = "hashicorp/alicloud"
    }
  }
}

variable "region" {
  default = "cn-shanghai"
}
provider "alicloud" {
  region = var.region
  shared_credentials_file = "/root/.aliyun/config.json"
  profile                 = "TFAkProfile"
}


resource "random_integer" "default" {
  min = 10000
  max = 99999
}

module "remote_state" {
  source = "terraform-alicloud-modules/remote-backend/alicloud"

  create_backend_bucket = true

  create_ots_lock_instance = true
  # 注意，为了避免OTS实例名称的冲突，此处需要指定自己的OTS Instance名称
  # 如果指定的OTS Instance已经存在，那么需要设置 create_ots_lock_instance = false 
  backend_ots_lock_instance = "ots-i-${random_integer.default.result}"

  create_ots_lock_table = true
  # 注意，如果想要自定义OTS Table或者使用已经存在的Table，可以通过参数backend_ots_lock_table来指定
  # 如果指定的OTS Table已经存在，那么需要设置 create_ots_lock_table = false
  # backend_ots_lock_table  = "<your-ots-table-name>"

  region        = var.region
  state_name    = "prod/terraform.tfstate"
  encrypt_state = true
}