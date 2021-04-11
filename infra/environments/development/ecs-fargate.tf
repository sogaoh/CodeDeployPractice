module "ecs-fargate" {
  source = "../../modules/central/ecs-fargate"

  tags_env = "development"

  environment_name = "development"
  product_name = "codedeploy-practice"

  ################################
  # IAM
  ################################
  region = var.region
  account_id = var.account_id

  ################################
  # CloudWatch Log Group
  ################################
  ecs_service_name = "maintenance"

  ################################
  # ECS Cluster
  ################################
  ecs_cluster_name = "dev-codedeploy-practice"

  ################################
  # ALB
  ################################
  alb_name = "dev-codedeploy-practice-alb"
  alb_default_target_name = "dev-codedeploy-practice-ecs"
  //certificate_arn = var.certificate_arn

  vpc_id = module.network.out_vpc_id
  public_subnet_a_id = module.network.out_public_subnet_a_id
  public_subnet_c_id = module.network.out_public_subnet_c_id
  sg_public_id = module.security.out_sg_public_id
}
