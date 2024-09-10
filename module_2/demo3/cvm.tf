terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "~> 1.230.0"
    }
  }
}


terraform {
  backend "oss" {
    profile                 = "TFAkProfile"
    bucket              = "terraform-remote-backend-28929d53-ed97-2697-a788-0d0fd2ef2cc4"
    key                 = "prod/terraform.tfstate"
    acl                 = "private"
    region              = "cn-shanghai"
    encrypt             = "true"
    tablestore_endpoint = "https://ots-i-87169.cn-shanghai.ots.aliyuncs.com"
    tablestore_table    = "terraform_remote_backend_lock_table_28929d53_ed97_2697_a788_0d0fd2ef2cc4"
  }
}


# Configure the AliCloud Provider

provider "alicloud" {
  region                  = "cn-shanghai"
  shared_credentials_file = "/root/.aliyun/config.json"
  profile                 = "TFAkProfile"
}


variable "name" {
  default = "terraform-example"
}

data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.name
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "172.16.0.0/24"
  #zone_id      = data.alicloud_zones.default.zones.0.id
  zone_id      = "cn-shanghai-g"
  vswitch_name = var.name
}

# Create a new Security in a VPC
resource "alicloud_security_group" "group" {
  name        = var.name
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}


resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

# Create a kms to encrypt the disk
#resource "alicloud_kms_key" "key" {
#  description            = "Hello KMS"
#  pending_window_in_days = "7"
#  status                 = "Enabled"
#}

resource "alicloud_instance" "instance" {
  #availability_zone = data.alicloud_zones.default.zones.0.id
  availability_zone = "cn-shanghai-g"
  security_groups   = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.t5-lc1m2.small"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = var.name
  system_disk_description    = "system_disk_description"
  image_id                   = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name              = var.name
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
  data_disks {
    name        = "data-disk"
    size        = 20
    category    = "cloud_efficiency"
    description = "disk-description"
    encrypted   = false
    #kms_key_id  = alicloud_kms_key.key.id
  }
}


resource "random_integer" "default" {
  min = 10000
  max = 99999
}

# public_key = `cat ~/.ssh/id_rsa.pub`
// Import an existing public key to build a alicloud key pair
resource "alicloud_ecs_key_pair" "example" {
  key_pair_name = "tf-example-shawn-${random_integer.default.result}"
  public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiHfL9yykBQPXX7H9oYPQNn9GQrNguQ+BLvzej3kmWNIv9LX5lSIVnNNFY1B47fCiFKcSvYHmYqETlg7g4lRu9DBpldecgZ/OCZC/eECEMKMvTm1yBFVHQX3rZRRglRg8tWz7T0My81kHCHs+vfyGM42n31m0tQ+HfKT3hU20nnRESUMZkGZB9HI8atqkzPRH4mTbfRchg0CyKF0V0qAEKowtEYMrkheQlbrC4DndwwZqr+N1V95j730qMd6ppoMGPGouSQCYHns/2Zck38tgV0T5waVWbMb4uupH2H3/OTj4ydDcAfrusAhVqrZHHE/UMdj2gr72dyYezmRyrHQfZmyoD5WQrtaPNgBcaC3jn5jNYi3rFmuqiDrqHHp2NbPPNqXPpob3tTxuIwwUHqG0gNGqalwQ3dvrNY7G9nBSpuX+yYyrwNNSWobL4iVWrBGrX4yNPhpwPnoIeXpyzutKuMVMufGqv4K0HAZsIBGX+1cfn5F8pkQZBcr/nES5uIzs="
}

resource "alicloud_ecs_key_pair_attachment" "example" {
  key_pair_name = alicloud_ecs_key_pair.example.key_pair_name
  instance_ids  = [alicloud_instance.instance.id]
}