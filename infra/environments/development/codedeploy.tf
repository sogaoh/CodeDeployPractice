module "codedeploy" {
  source = "../../modules/central/codedeploy"

  tags_env = "development"

  environment_name = "development"
  product_name = "codedeploy-practice"

  ################################
  # CodeDeploy
  ################################
  code_deploy_app_name = "dev-codedeploy-practice"
  code_deploy_group_name = "maintenance-bg"

  alb_listener_arns = [
    module.ecs-fargate.out_blue_listener_arn,
    //module.ecs-fargate.out_green_listener_arn,
  ]
  target_group_blue_name = module.ecs-fargate.out_alb_tg_blue_name
  target_group_green_name = module.ecs-fargate.out_alb_tg_green_name

  ecs_cluster_name = module.ecs-fargate.out_ecs_cluster_name
  ecs_service_name = var.ecs_service_name
}
