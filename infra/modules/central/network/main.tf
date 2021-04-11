# @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
# @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Networking.html
# @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html

# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association

################################
# VPC
################################
resource "aws_vpc" "vpc_module" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
    Env = var.tags_env
  }
}


################################
# Subnet
################################
##------------------------------
## Public A
resource "aws_subnet" "public_subnet_a_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1a"

  cidr_block = var.public_subnet_a_cidr_block
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.public_subnet_a_name
    Env = var.tags_env
  }
}

##------------------------------
## Public C
resource "aws_subnet" "public_subnet_c_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1c"

  cidr_block = var.public_subnet_c_cidr_block
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.public_subnet_c_name
    Env = var.tags_env
  }
}


##------------------------------
## Private A
resource "aws_subnet" "private_subnet_a_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1a"

  cidr_block = var.private_subnet_a_cidr_block
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.private_subnet_a_name
    Env = var.tags_env
  }
}


##------------------------------
## Private D
resource "aws_subnet" "private_subnet_d_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1d"

  cidr_block = var.private_subnet_d_cidr_block
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.private_subnet_d_name
    Env = var.tags_env
  }
}


##------------------------------
## Storage C
resource "aws_subnet" "storage_subnet_c_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1c"

  cidr_block = var.storage_subnet_c_cidr_block
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.storage_subnet_c_name
    Env = var.tags_env
  }
}

##------------------------------
## Storage D
resource "aws_subnet" "storage_subnet_d_module" {
  vpc_id = aws_vpc.vpc_module.id
  availability_zone = "ap-northeast-1d"

  cidr_block = var.storage_subnet_d_cidr_block
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false

  tags = {
    Name = var.storage_subnet_d_name
    Env = var.tags_env
  }
}


################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw_module" {
  vpc_id = aws_vpc.vpc_module.id

  tags = {
    Name = var.igw_name
    Env = var.tags_env
  }
}

################################
# NAT Gateway
################################
##------------------------------
## NAT-GW A
resource "aws_nat_gateway" "nat_gw_a_module" {
  allocation_id = aws_eip.nat_gw_eip_a_module.id
  subnet_id = aws_subnet.public_subnet_a_module.id
  depends_on = [aws_internet_gateway.igw_module]

  tags = {
    Name = var.nat_gw_a_name
    Env = var.tags_env
  }
}
resource "aws_eip" "nat_gw_eip_a_module" {
  vpc = true
  depends_on = [aws_internet_gateway.igw_module]

  tags = {
    Env = var.tags_env
  }
}

##------------------------------
## NAT-GW C
resource "aws_nat_gateway" "nat_gw_c_module" {
  allocation_id = aws_eip.nat_gw_eip_c_module.id
  subnet_id = aws_subnet.public_subnet_c_module.id
  depends_on = [aws_internet_gateway.igw_module]

  tags = {
    Name = var.nat_gw_c_name
    Env = var.tags_env
  }
}
resource "aws_eip" "nat_gw_eip_c_module" {
  vpc = true
  depends_on = [aws_internet_gateway.igw_module]

  tags = {
    Env = var.tags_env
  }
}


################################
# Route Table
################################
##------------------------------
## Public
resource "aws_route_table" "public_rt_module" {
  vpc_id = aws_vpc.vpc_module.id
  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_internet_gateway.igw_module.id
  }

  tags = {
    Name = var.public_rt_name
    Env = var.tags_env
  }
}

resource "aws_route_table_association" "rt_assoc_a_module" {
  route_table_id = aws_route_table.public_rt_module.id
  subnet_id = aws_subnet.public_subnet_a_module.id
}

resource "aws_route_table_association" "rt_assoc_c_module" {
  route_table_id = aws_route_table.public_rt_module.id
  subnet_id = aws_subnet.public_subnet_c_module.id
}

##------------------------------
## Private A
resource "aws_route_table" "private_rt_a_module" {
  vpc_id = aws_vpc.vpc_module.id

  route {
    cidr_block = var.private_rt_a_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw_a_module.id
  }

  tags = {
    Name = var.private_rt_a_name
    Env = var.tags_env
  }
}

resource "aws_route_table_association" "private_rt_assoc_a_module" {
  subnet_id = aws_subnet.private_subnet_a_module.id
  route_table_id = aws_route_table.private_rt_a_module.id
}

##------------------------------
## Private D
resource "aws_route_table" "private_rt_d_module" {
  vpc_id = aws_vpc.vpc_module.id

  route {
    cidr_block = var.private_rt_d_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw_c_module.id
  }

  tags = {
    Name = var.private_rt_d_name
    Env = var.tags_env
  }
}

resource "aws_route_table_association" "private_rt_assoc_d_module" {
  subnet_id = aws_subnet.private_subnet_d_module.id
  route_table_id = aws_route_table.private_rt_d_module.id
}

##------------------------------
## Storage C
resource "aws_route_table" "storage_rt_c_module" {
  vpc_id = aws_vpc.vpc_module.id

  route {
    cidr_block = var.storage_rt_c_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw_c_module.id
  }

  tags = {
    Name = var.storage_rt_c_name
    Env = var.tags_env
  }
}
resource "aws_route_table_association" "storage_rt_assoc_c_module" {
  subnet_id = aws_subnet.storage_subnet_c_module.id
  route_table_id = aws_route_table.storage_rt_c_module.id
}

##------------------------------
## Storage D
resource "aws_route_table" "storage_rt_d_module" {
  vpc_id = aws_vpc.vpc_module.id

  route {
    cidr_block = var.storage_rt_d_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw_c_module.id
  }

  tags = {
    Name = var.storage_rt_d_name
    Env = var.tags_env
  }
}
resource "aws_route_table_association" "storage_rt_assoc_d_module" {
  subnet_id = aws_subnet.storage_subnet_d_module.id
  route_table_id = aws_route_table.storage_rt_d_module.id
}


################################
# VPC Endpoint (Gateway)
################################
/*
  VPC Endpoint for S3
  Endpoint for pulling container image.
*/
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
  service_type = "Gateway"
}
resource "aws_vpc_endpoint" "vpc_endpoint_s3_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type   = "Gateway"

  tags = {
    Name = var.vpc_endpoint_s3_name
    Env = var.tags_env
  }
}
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_s3_public_route" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3_module.id
  route_table_id  = aws_route_table.public_rt_module.id
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_s3_route_a" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3_module.id
  route_table_id  = aws_route_table.private_rt_a_module.id
}
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_s3_route_d" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3_module.id
  route_table_id  = aws_route_table.private_rt_d_module.id
}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_s3_storage_route_c" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3_module.id
  route_table_id  = aws_route_table.storage_rt_c_module.id
}
resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_s3_storage_route_d" {
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint_s3_module.id
  route_table_id  = aws_route_table.storage_rt_d_module.id
}


################################
# VPC Endpoint (Interface)
################################
/*
  VPC Endpoint for ECR DKR
  Endpoint for executing docker command.
*/
data "aws_vpc_endpoint_service" "ecr_dkr" {
  service = "ecr.dkr"
  service_type = "Interface"
}
resource "aws_vpc_endpoint" "vpc_endpoint_ecr_dkr_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.ecr_dkr.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = var.interface_vpc_endpoint_subnets
  security_group_ids  = var.ecr_dkr_endpoint_security_group_ids
  private_dns_enabled = true

  tags = {
    Name = var.vpc_endpoint_ecr_dkr_name
    Env = var.tags_env
  }
}


data "aws_vpc_endpoint_service" "ecr_api" {
  service = "ecr.api"
  service_type = "Interface"
}
resource "aws_vpc_endpoint" "vpc_endpoint_ecr_api_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.ecr_api.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = var.interface_vpc_endpoint_subnets
  security_group_ids  = var.ecr_api_endpoint_security_group_ids
  private_dns_enabled = true

  tags = {
    Name = var.vpc_endpoint_ecr_api_name
    Env = var.tags_env
  }
}

/*
  VPC Endpoint for SSM
*/
data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
  service_type = "Interface"
}
resource "aws_vpc_endpoint" "vpc_endpoint_ssm_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.ssm.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = var.interface_vpc_endpoint_subnets
  security_group_ids  = var.ssm_endpoint_security_group_ids
  private_dns_enabled = true

  tags = {
    Name = var.vpc_endpoint_ssm_name
    Env = var.tags_env
  }
}

/*
  VPC Endpoint for logs
  Endpoint for sending logs to CloudWatch Logs
*/
data "aws_vpc_endpoint_service" "logs" {
  service = "logs"
  service_type = "Interface"
}
resource "aws_vpc_endpoint" "vpc_endpoint_logs_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.logs.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = var.interface_vpc_endpoint_subnets
  security_group_ids  = var.cloudwatch_logs_endpoint_security_group_ids
  private_dns_enabled = true

  tags = {
    Name = var.vpc_endpoint_logs_name
    Env = var.tags_env
  }
}


/*
  VPC Endpoint for SSM Messages
+*/

data "aws_vpc_endpoint_service" "ssm_messages" {
  service = "ssmmessages"
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "vpc_endpoint_ssm_messages_module" {
  vpc_id            = aws_vpc.vpc_module.id
  service_name      = data.aws_vpc_endpoint_service.ssm_messages.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = var.interface_vpc_endpoint_subnets
  security_group_ids  = var.ssm_messages_endpoint_security_group_ids
  private_dns_enabled = true

  tags = {
    Name = var.vpc_endpoint_ssm_messages_name
    Env = var.tags_env
  }
}
