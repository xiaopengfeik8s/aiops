

# Configure the AliCloud Provider

provider "alicloud" {
  region                  = "cn-hongkong"
  access_key = var.secret_id
  secret_key = var.secret_key
  #shared_credentials_file = "/root/.aliyun/config.json"
  #profile                 = "TFAkProfile"
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
  zone_id      = "cn-hongkong-b"
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
  availability_zone = "cn-hongkong-b"
  security_groups   = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.t5-lc1m2.large"
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
  public_key    = file(var.public_key_path)
}

resource "alicloud_ecs_key_pair_attachment" "example" {
  key_pair_name = alicloud_ecs_key_pair.example.key_pair_name
  instance_ids  = [alicloud_instance.instance.id]
}