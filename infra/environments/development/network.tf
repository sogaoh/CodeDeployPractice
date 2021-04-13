module "network" {
  source = "../../modules/central/network"

  tags_env = "development"

  ################################
  # VPC
  ################################
  vpc_name = "dev-codedeploy-practice-vpc"
  vpc_cidr_block = "10.0.0.0/16"

  ################################
  # Subnet
  ################################
  ## Public
  public_subnet_a_name = "dev-codedeploy-practice-public-subnet-a"
  public_subnet_a_cidr_block = "10.0.0.0/24"

  public_subnet_c_name = "dev-codedeploy-practice-public-subnet-c"
  public_subnet_c_cidr_block = "10.0.1.0/24"

  ## Private
  private_subnet_a_name = "dev-codedeploy-practice-private-subnet-a"
  private_subnet_a_cidr_block = "10.0.100.0/24"

  private_subnet_c_name = "dev-codedeploy-practice-private-subnet-d"
  private_subnet_c_cidr_block = "10.0.101.0/24"

  ## Storage
  storage_subnet_c_name = "dev-codedeploy-practice-storage-subnet-a"
  storage_subnet_c_cidr_block = "10.0.200.0/24"

  storage_subnet_a_name = "dev-codedeploy-practice-storage-subnet-d"
  storage_subnet_a_cidr_block = "10.0.201.0/24"


  ################################
  # Internet Gateway
  ################################
  igw_name = "dev-codedeploy-practice-igw"

  ################################
  # NAT Gateway
  ################################
  nat_gw_a_name = "dev-codedeploy-practice-nat-gw-a"
  nat_gw_c_name = "dev-codedeploy-practice-nat-gw-c"

  ################################
  # Route Table
  ################################
  ## Public
  public_rt_name = "dev-codedeploy-practice-public-rt"
  public_rt_cidr_block = "0.0.0.0/0"

  ## Private
  private_rt_a_name = "dev-codedeploy-practice-private-a-rt"
  private_rt_a_cidr_block = "0.0.0.0/0"

  private_rt_c_name = "dev-codedeploy-practice-private-d-rt"
  private_rt_c_cidr_block = "0.0.0.0/0"

  ## Storage
  storage_rt_c_name = "dev-codedeploy-practice-storage-c-rt"
  storage_rt_c_cidr_block = "0.0.0.0/0"

  storage_rt_a_name = "dev-codedeploy-practice-storage-d-rt"
  storage_rt_a_cidr_block = "0.0.0.0/0"


  ################################
  # VPC Endpoint (Gateway)
  ################################
  vpc_endpoint_s3_name = "dev-codedeploy-practice-s3-vpc-endpoint"

  interface_vpc_endpoint_subnets = [
    module.network.out_private_subnet_a_id,
    module.network.out_private_subnet_d_id,
  ]

  ################################
  # VPC Endpoint (Interface)
  ################################
  vpc_endpoint_ecr_dkr_name = "dev-codedeploy-practice-ecr-dkr-vpc-endpoint"
  ecr_dkr_endpoint_security_group_ids = [
    module.security.out_sg_private_id,
    module.security.out_sg_vpc_endpoint_id,
  ]
  vpc_endpoint_ecr_api_name = "dev-codedeploy-practice-ecr-api-vpc-endpoint"
  ecr_api_endpoint_security_group_ids = [
    module.security.out_sg_private_id,
    module.security.out_sg_vpc_endpoint_id,
  ]
  vpc_endpoint_ssm_name = "dev-codedeploy-practice-ssm-vpc-endpoint"
  ssm_endpoint_security_group_ids = [
    module.security.out_sg_private_id,
    module.security.out_sg_storage_id,
    module.security.out_sg_vpc_endpoint_id,
  ]
  vpc_endpoint_logs_name = "dev-codedeploy-practice-logs-vpc-endpoint"
  cloudwatch_logs_endpoint_security_group_ids = [
    module.security.out_sg_public_id,
    module.security.out_sg_private_id,
    module.security.out_sg_storage_id,
    module.security.out_sg_vpc_endpoint_id,
  ]
  vpc_endpoint_ssm_messages_name = "dev-codedeploy-practice-ssm-messages-vpc-endpoint"
  ssm_messages_endpoint_security_group_ids = [
    module.security.out_sg_private_id,
    module.security.out_sg_storage_id,
    module.security.out_sg_vpc_endpoint_id,
  ]
}
