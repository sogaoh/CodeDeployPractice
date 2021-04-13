################################
# VPC
################################
output "out_vpc_id" {
    value = aws_vpc.vpc_module.id
}
output "out_vpc_cidr_block" {
    value = aws_vpc.vpc_module.cidr_block
}


################################
# Subnet
################################
## Public
output "out_public_subnet_a_id" {
    value = aws_subnet.public_subnet_a_module.id
}
output "out_public_subnet_a_cidr_block" {
    value = aws_subnet.public_subnet_a_module.cidr_block
}

output "out_public_subnet_c_id" {
    value = aws_subnet.public_subnet_c_module.id
}
output "out_public_subnet_c_cidr_block" {
    value = aws_subnet.public_subnet_c_module.cidr_block
}

## Private
output "out_private_subnet_a_id" {
  value = aws_subnet.private_subnet_a_module.id
}
output "out_private_subnet_a_cidr_block" {
  value = aws_subnet.private_subnet_a_module.cidr_block
}

output "out_private_subnet_d_id" {
    value = aws_subnet.private_subnet_c_module.id
}
output "out_private_subnet_d_cidr_block" {
    value = aws_subnet.private_subnet_c_module.cidr_block
}

## Storage
output "out_storage_subnet_c_id" {
  value = aws_subnet.storage_subnet_c_module.id
}
output "out_storage_subnet_c_cidr_block" {
  value = aws_subnet.storage_subnet_c_module.cidr_block
}

output "out_storage_subnet_d_id" {
    value = aws_subnet.storage_subnet_a_module.id
}
output "out_storage_subnet_d_cidr_block" {
    value = aws_subnet.storage_subnet_a_module.cidr_block
}


################################
# Internet Gateway
################################
output "out_igw_id" {
    value = aws_internet_gateway.igw_module.id
}


################################
# NAT Gateway
################################
output "out_nat_gw_a_eip" {
    value = aws_nat_gateway.nat_gw_a_module.public_ip
}
output "out_nat_gw_c_eip" {
    value = aws_nat_gateway.nat_gw_c_module.public_ip
}


################################
# Route Table
################################
## Public
output "out_public_rt_id" {
    value = aws_route_table.public_rt_module.id
}

## Private
output "out_private_rt_a_id" {
  value = aws_route_table.private_rt_a_module.id
}
output "out_private_rt_d_id" {
    value = aws_route_table.private_rt_c_module.id
}

## Storage
output "out_storage_rt_c_id" {
  value = aws_route_table.storage_rt_c_module.id
}
output "out_storage_rt_d_id" {
    value = aws_route_table.storage_rt_a_module.id
}


################################
# VPC Endpoint (Gateway)
################################
output "out_vpc_endpoint_s3_id" {
  value = aws_vpc_endpoint.vpc_endpoint_s3_module.id
}

################################
# VPC Endpoint (Interface)
################################
output "out_vpc_endpoint_ecr_dkr_id" {
  value = aws_vpc_endpoint.vpc_endpoint_ecr_dkr_module.id
}

output "out_vpc_endpoint_ecr_api_id" {
  value = aws_vpc_endpoint.vpc_endpoint_ecr_api_module.id
}

output "out_vpc_endpoint_ssm_id" {
  value = aws_vpc_endpoint.vpc_endpoint_ssm_module.id
}

output "out_vpc_endpoint_logs_id" {
  value = aws_vpc_endpoint.vpc_endpoint_logs_module.id
}

output "out_vpc_endpoint_ssm_messages_id" {
  value = aws_vpc_endpoint.vpc_endpoint_ssm_messages_module.id
}
