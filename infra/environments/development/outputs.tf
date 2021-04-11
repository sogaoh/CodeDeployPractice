################################
# VPC
################################
output "out_vpc_id" {
  value = module.network.out_vpc_id
}


################################
# Subnet
################################
output "out_public_subnet_a_id" {
  value = module.network.out_public_subnet_a_id
}
output "out_public_subnet_c_id" {
  value = module.network.out_public_subnet_c_id
}

output "out_private_subnet_a_id" {
  value = module.network.out_private_subnet_a_id
}
output "out_private_subnet_d_id" {
  value = module.network.out_private_subnet_d_id
}

output "out_storage_subnet_c_id" {
  value = module.network.out_storage_subnet_c_id
}
output "out_storage_subnet_d_id" {
  value = module.network.out_storage_subnet_d_id
}


################################
# NAT Gateway
################################
output "out_nat_gw_a_eip" {
  value = module.network.out_nat_gw_a_eip
}
output "out_nat_gw_c_eip" {
  value = module.network.out_nat_gw_c_eip
}


################################
# VPC Endpoint
################################
# Gateway
output "out_vpc_endpoint_s3_id" {
  value = module.network.out_vpc_endpoint_s3_id
}

# Interface
output "out_vpc_endpoint_ecr_dkr_id" {
  value = module.network.out_vpc_endpoint_ecr_dkr_id
}
output "out_vpc_endpoint_ecr_api_id" {
  value = module.network.out_vpc_endpoint_ecr_api_id
}
output "out_vpc_endpoint_ssm_id" {
  value = module.network.out_vpc_endpoint_ssm_id
}
output "out_vpc_endpoint_logs_id" {
  value = module.network.out_vpc_endpoint_logs_id
}
output "out_vpc_endpoint_ssm_messages_id" {
  value = module.network.out_vpc_endpoint_ssm_messages_id
}


################################
# Security Group
################################
output "out_sg_public_id" {
  value = module.security.out_sg_public_id
}

output "out_sg_private_id" {
  value = module.security.out_sg_private_id
}

output "out_sg_storage_id" {
  value = module.security.out_sg_storage_id
}

output "out_sg_vpc_endpoint_id" {
  value = module.security.out_sg_vpc_endpoint_id
}
