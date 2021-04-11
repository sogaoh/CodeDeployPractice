################################
# VPC
################################
variable "vpc_name" {}
variable "vpc_cidr_block" {}


################################
# Subnet
################################
## Public
variable "public_subnet_a_name" {}
variable "public_subnet_a_cidr_block" {}

variable "public_subnet_c_name" {}
variable "public_subnet_c_cidr_block" {}

## Private
variable "private_subnet_a_name" {}
variable "private_subnet_a_cidr_block" {}

variable "private_subnet_d_name" {}
variable "private_subnet_d_cidr_block" {}

## Storage
variable "storage_subnet_c_name" {}
variable "storage_subnet_c_cidr_block" {}

variable "storage_subnet_d_name" {}
variable "storage_subnet_d_cidr_block" {}


################################
# Internet Gateway
################################
variable "igw_name" {}


################################
# NAT Gateway
################################
variable "nat_gw_a_name" {}
variable "nat_gw_c_name" {}


################################
# Route Table
################################
## Public
variable "public_rt_name" {}
variable "public_rt_cidr_block" {}

## Private
variable "private_rt_a_name" {}
variable "private_rt_a_cidr_block" {}

variable "private_rt_d_name" {}
variable "private_rt_d_cidr_block" {}

## Storage
variable "storage_rt_c_name" {}
variable "storage_rt_c_cidr_block" {}

variable "storage_rt_d_name" {}
variable "storage_rt_d_cidr_block" {}


################################
# VPC Endpoint (Gateway)
################################
variable "vpc_endpoint_s3_name" {}

################################
# VPC Endpoint (Interface)
################################
variable "interface_vpc_endpoint_subnets" {}
variable "vpc_endpoint_ecr_dkr_name" {}
variable "ecr_dkr_endpoint_security_group_ids" {}
variable "vpc_endpoint_ecr_api_name" {}
variable "ecr_api_endpoint_security_group_ids" {}
variable "vpc_endpoint_ssm_name" {}
variable "ssm_endpoint_security_group_ids" {}
variable "vpc_endpoint_logs_name" {}
variable "cloudwatch_logs_endpoint_security_group_ids" {}
variable "vpc_endpoint_ssm_messages_name" {}
variable "ssm_messages_endpoint_security_group_ids" {}


################################
# etc
################################
## tags
variable "tags_env" {}
