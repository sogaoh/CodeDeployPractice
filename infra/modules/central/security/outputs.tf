################################
# Public SG
################################
output "out_sg_public_id" {
    value = aws_security_group.sg_public_module.id
}

################################
# Private SG
################################
output "out_sg_private_id" {
    value = aws_security_group.sg_private_module.id
}

################################
# Storage SG
################################
output "out_sg_storage_id" {
    value = aws_security_group.sg_storage_module.id
}

################################
# VPC Endpoint SG
################################
output "out_sg_vpc_endpoint_id" {
  value = aws_security_group.sg_vpc_endpoint_module.id
}
