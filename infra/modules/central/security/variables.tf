################################
# Public SG
################################
variable "sg_public_name" {}
variable "sg_public_description" {}

variable "sg_public_80_cidr_blocks" {}
variable "sg_public_443_cidr_blocks" {}
variable "sg_public_8080_cidr_blocks" {}
variable "sg_public_icmp_cidr_blocks" {}
variable "sg_public_egress_cidr_blocks" {}


################################
# Private SG
################################
variable "sg_private_name" {}
variable "sg_private_description" {}

variable "sg_private_443_cidr_blocks" {}
variable "sg_private_8080_cidr_blocks" {}
variable "sg_private_icmp_cidr_blocks" {}
variable "sg_private_8088_cidr_blocks" {}
variable "sg_private_egress_cidr_blocks" {}


################################
# Storage SG
################################
variable "sg_storage_name" {}
variable "sg_storage_description" {}

variable "sg_storage_icmp_cidr_blocks" {}
variable "sg_storage_egress_cidr_blocks" {}


################################
# VPC Endpoint SG
################################
variable "sg_vpc_endpoint_name" {}
variable "sg_vpc_endpoint_description" {}

variable "sg_vpc_endpoint_ingress_cidr_blocks" {}
variable "sg_vpc_endpoint_egress_cidr_blocks" {}


################################
# etc
################################
## tags
variable "tags_pj"  {}
variable "tags_env" {}


## external
variable "vpc_id" {}
