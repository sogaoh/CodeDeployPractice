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
  zone_id =  var.dns_zone_id
  certificate_arn = var.wc_certificate_arn
  bg_alb_name = "dev-codedeploy-practice-bg-alb"
  dns_bg_sub_domain = "dev-codedeploy-practice-bg"
  dns_cname_ttl = 3600

  alb_blue_target_name = "dev-codedeploy-practice-blue"
  alb_green_target_name = "dev-codedeploy-practice-green"

  vpc_id = module.network.out_vpc_id
  public_subnet_a_id = module.network.out_public_subnet_a_id
  public_subnet_c_id = module.network.out_public_subnet_c_id
  sg_public_id = module.security.out_sg_public_id
}
