provider "tencentcloud" {
  secret_id  = var.secret_id
  secret_key = var.secret_key
  region     = var.region
}

data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

data "tencentcloud_instance_types" "default" {
  filter {
    name   = "instance-family"
    values = ["SA5"]
  }

  filter {
    name   = "zone"
    values = ["${var.availability_zone}"]
  }

  cpu_core_count = var.cpu
}

data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# resource "tencentcloud_key_pair" "key" {
#   key_name   = "tf_key"
#   public_key = file("ssh-key/id_rsa.pub")
# }

# Create a web server without public ip
resource "tencentcloud_instance" "ubuntu" {
  instance_name              = var.instance_name
  availability_zone          = var.availability_zone
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_BSSD"
  system_disk_size           = 100
  hostname                   = var.instance_name
  vpc_id                     = length(var.vpc_id) > 0 ? var.vpc_id : tencentcloud_vpc.tf_vpc.id
  subnet_id                  = length(var.subnet_id) > 0 ? var.subnet_id : tencentcloud_subnet.tf_service_subnet.id
  instance_charge_type       = var.instance_charge_type
  internet_max_bandwidth_out = 100
  allocate_public_ip         = true
  orderly_security_groups    = [tencentcloud_security_group.web_sg.id]
  password                   = var.password

  //data_disks {
  // data_disk_type = "CLOUD_PREMIUM"
  // data_disk_size = 50
  //}

  tags = var.tags
}
