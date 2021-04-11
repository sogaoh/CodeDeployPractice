# @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

################################
# Public SG
################################
resource "aws_security_group" "sg_public_module" {
  vpc_id = var.vpc_id
  name = var.sg_public_name
  description = var.sg_public_description

  tags = {
    Name = var.sg_public_name
    Env = var.tags_env
  }
}

resource "aws_security_group_rule" "sg_rule_public_80_module" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = var.sg_public_80_cidr_blocks
  description = "Public SG ingress HTTP 80 Rule"

  security_group_id = aws_security_group.sg_public_module.id
}

resource "aws_security_group_rule" "sg_rule_public_443_module" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = var.sg_public_443_cidr_blocks
  description = "Public SG ingress HTTPS 443 Rule"

  security_group_id = aws_security_group.sg_public_module.id
}

resource "aws_security_group_rule" "sg_rule_public_icmp_module" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = var.sg_public_icmp_cidr_blocks
  description = "Public SG ingress ICMP Rule"

  security_group_id = aws_security_group.sg_public_module.id
}

resource "aws_security_group_rule" "sg_rule_public_out_module" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = var.sg_public_egress_cidr_blocks
  description = "Public SG egress Rule"

  security_group_id = aws_security_group.sg_public_module.id
}


################################
# Private SG
################################
resource "aws_security_group" "sg_private_module" {
  vpc_id = var.vpc_id
  name = var.sg_private_name
  description = var.sg_private_description

  tags = {
    Name = var.sg_private_name
    Env = var.tags_env
  }
}

resource "aws_security_group_rule" "sg_rule_private_80_module" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  description = "Private SG ingress HTTP 80 Rule"

  security_group_id = aws_security_group.sg_private_module.id

  source_security_group_id = aws_security_group.sg_public_module.id
}

resource "aws_security_group_rule" "sg_rule_private_443_module" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = var.sg_private_443_cidr_blocks
  description = "Private SG ingress HTTPS 443 Rule"

  security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_private_9000_module" {
  type = "ingress"
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  cidr_blocks = var.sg_private_9000_cidr_blocks
  description = "Private SG ingress HTTP 9000 Rule"

  security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_private_icmp_module" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = var.sg_private_icmp_cidr_blocks
  description = "Private SG ingress ICMP Rule"

  security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_private_8088_module" {
  type = "ingress"
  from_port = 8088
  to_port = 8088
  protocol = "tcp"
  cidr_blocks = var.sg_private_8088_cidr_blocks
  description = "Private SG ingress HTTP 8088 Rule"

  security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_private_out_module" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = var.sg_private_egress_cidr_blocks
  description = "Private SG egress Rule"

  security_group_id = aws_security_group.sg_private_module.id
}

################################
# Storage SG
################################
resource "aws_security_group" "sg_storage_module" {
  vpc_id = var.vpc_id
  name = var.sg_storage_name
  description = var.sg_storage_description

  tags = {
    Name = var.sg_storage_name
    Env = var.tags_env
  }
}

resource "aws_security_group_rule" "sg_rule_storage_3306_module" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  description = "Storage SG ingress TCP 3306 (MySQL) Rule"

  security_group_id = aws_security_group.sg_storage_module.id

  source_security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_storage_6379_module" {
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  description = "Storage SG ingress TCP 6379 (Redis) Rule"

  security_group_id = aws_security_group.sg_storage_module.id

  source_security_group_id = aws_security_group.sg_private_module.id
}

resource "aws_security_group_rule" "sg_rule_storage_icmp_module" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = var.sg_storage_icmp_cidr_blocks
  description = "Storage SG ingress ICMP Rule"

  security_group_id = aws_security_group.sg_storage_module.id
}

resource "aws_security_group_rule" "sg_rule_storage_out_module" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = var.sg_storage_egress_cidr_blocks
  description = "Storage SG egress Rule"

  security_group_id = aws_security_group.sg_storage_module.id
}


################################
# VPC Endpoint SG
################################
resource "aws_security_group" "sg_vpc_endpoint_module" {
  vpc_id = var.vpc_id
  name = var.sg_vpc_endpoint_name
  description = var.sg_vpc_endpoint_description

  tags = {
    Name = var.sg_vpc_endpoint_name
    Env = var.tags_env
  }
}

resource "aws_security_group_rule" "sg_rule_vpc_endpoint_in_443_module" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = var.sg_vpc_endpoint_ingress_cidr_blocks
  description = "VPC Endpoint SG ingress HTTPS Rule"

  security_group_id = aws_security_group.sg_storage_module.id
}

resource "aws_security_group_rule" "sg_rule_vpc_endpoint_out_443_module" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = var.sg_vpc_endpoint_egress_cidr_blocks
  description = "VPC Endpoint SG egress HTTPS Rule"

  security_group_id = aws_security_group.sg_vpc_endpoint_module.id
}
