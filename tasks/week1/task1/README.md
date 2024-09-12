# 实践 Terraform，开通腾讯云虚拟机，并安装 Docker。
> 我选择使用阿里云来完成这个任务。
---
## 1. 安装 Terraform
参考：
- [install terraform](https://developer.hashicorp.com/terraform/downloads)

```shell
#Ubuntu/Debian
wget -O hashicorp-key.gpg https://apt.releases.hashicorp.com/gpg
cat hashicorp-key.gpg |gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update &&   apt install terraform
rm hashicorp-key.gpg 
```

---




## 2. 配置使用user_data去执行docker安装脚本
参考：
- [使用实例自定义数据在实例启动时自动执行命令或脚本](https://help.aliyun.com/zh/ecs/user-guide/overview-of-ecs-instance-user-data?spm=5176.ecsnewbuy.console-base_help.dexternal.62283675ukE6DU)
- [user_data](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance#user_data)
- [get-docker.sh](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)


```shell
cat >user-data.sh<<EOF
#!/usr/bin/env bash
 curl -fsSL https://get.docker.com -o get-docker.sh
 sh get-docker.sh
EOF
```

```shell
data "template_file" "user_data" {
  template = "${file("user-data.sh")}"
}

resource "alicloud_instance" "instance" {
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
  user_data = "${data.template_file.user_data.template}"
}
```
---
## 3. 执行

```shell
export secret_id="<Your-Access-Key-ID>"
export secret_key="<Your-Access-Key-Secret>"

root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# terraform init 
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# terraform  plan
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# terraform apply -auto-approve

```

---
## 4. 验证
```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# terraform output
public_ip = "47.239.115.145"


root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# ssh 47.239.115.145
The authenticity of host '47.239.115.145 (47.239.115.145)' can't be established.
ECDSA key fingerprint is SHA256:2AscQo4QEjkFkbJZy1itgAxBd2F9uLUEm0vTaKo35dc.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '47.239.115.145' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 18.04.2 LTS (GNU/Linux 4.15.0-52-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


Welcome to Alibaba Cloud Elastic Compute Service !

root@iZj6c2gu2l5k03xvxacno6Z:~# docker pull alpine 
Using default tag: latest
latest: Pulling from library/alpine
43c4264eed91: Pull complete 
Digest: sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
root@iZj6c2gu2l5k03xvxacno6Z:~# 

```

---
## 5. 销毁
```shell
root@devops-shawn-workspace:~/geekbang/aiops/tasks/week1/task1# terraform destroy -auto-approve
```



