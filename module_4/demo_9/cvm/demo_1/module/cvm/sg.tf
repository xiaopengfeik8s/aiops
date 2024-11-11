# Create security group with 4 rules
resource "tencentcloud_security_group" "web_sg" {
  name        = "web-sg"
  description = "make it accessible for both production and stage ports"
}

# be careful with the security group, we let all port open for demo purpose
resource "tencentcloud_security_group_rule" "all" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "http" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "80"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "https" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "443"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "k8s" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "6443"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "ssh" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "22"
  policy            = "accept"
}

# After install gitlab, nginx-controller will listen on 22
resource "tencentcloud_security_group_rule" "ssh_login" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "2222"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "thanos_grpc" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30901"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "thanos_http" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30902"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "grafana" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30080"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "thanos_web" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30090"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "thanos_bucket" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30092"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "thanos_compact" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "30093"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "submariner_1" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "udp"
  port_range        = "4500"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "submariner_2" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "udp"
  port_range        = "4490"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "submariner_3" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "udp"
  port_range        = "4800"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "icmp" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "icmp"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "web_egrees_any" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "egress"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
}
