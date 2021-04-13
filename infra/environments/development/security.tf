module "security" {
  source = "../../modules/central/security"

  tags_pj = "tp-edtech"
  tags_env = "staging"

  ################################
  # Security Group
  ################################
  vpc_id = module.network.out_vpc_id

  # Public SG
  sg_public_name = "dev-codedeploy-practice-sg-public"
  sg_public_description = "dev codedeploy-practice public security group"
  sg_public_80_cidr_blocks = [
    "0.0.0.0/0",
  ]
  sg_public_443_cidr_blocks = [
    "0.0.0.0/0",
  ]
  sg_public_8080_cidr_blocks = [
    "0.0.0.0/0",
  ]
  sg_public_icmp_cidr_blocks = [
    module.network.out_vpc_cidr_block,
  ]
  sg_public_egress_cidr_blocks = [
    "0.0.0.0/0",
  ]

  # Private SG
  sg_private_name = "dev-codedeploy-practice-sg-private"
  sg_private_description = "dev codedeploy-practice private security group"
  sg_private_icmp_cidr_blocks = [
    module.network.out_vpc_cidr_block,
  ]
  sg_private_443_cidr_blocks = [
    module.network.out_vpc_cidr_block,
    "127.0.0.1/32",
  ]
  sg_private_8080_cidr_blocks = [
    module.network.out_vpc_cidr_block,
    "127.0.0.1/32",
  ]
  sg_private_8088_cidr_blocks = [
    module.network.out_vpc_cidr_block,
    "127.0.0.1/32",
  ]
  sg_private_egress_cidr_blocks = [
    "0.0.0.0/0",
  ]

  # Storage SG
  sg_storage_name = "dev-codedeploy-practice-sg-storage"
  sg_storage_description = "dev codedeploy-practice storage security group"
  sg_storage_icmp_cidr_blocks = [
    module.network.out_vpc_cidr_block,
  ]
  sg_storage_egress_cidr_blocks = [
    "0.0.0.0/0",
  ]

  # VPC Endpoint SG
  sg_vpc_endpoint_name = "dev-codedeploy-practice-sg-vpc-endpoint"
  sg_vpc_endpoint_description = "dev codedeploy-practice vpc endpoint security group"
  sg_vpc_endpoint_ingress_cidr_blocks = [
    module.network.out_vpc_cidr_block,
  ]
  sg_vpc_endpoint_egress_cidr_blocks = [
    "0.0.0.0/0",
  ]
}
