terraform {
  required_version = "> 0.13.0"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.5"
    }
  }
}
