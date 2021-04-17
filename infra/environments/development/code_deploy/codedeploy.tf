module "codedeploy" {
  source = "../../../modules/central/codedeploy"

  tags_env = "development"

  environment_name = "development"
  product_name = "codedeploy-practice"

  account_id = var.account_id

  ################################
  # CodeDeploy
  ################################
  code_deploy_app_name = "dev-codedeploy-practice"
  code_deploy_group_name = "maintenance-bg"
  wait_time_in_minutes = 5

  alb_primary_listener_arn = [
    var.primary_listener_arn
  ]
  alb_secondary_listener_arn = [
    var.secondary_listener_arn
  ]

  target_group_blue_name = var.tg_blue_name
  target_group_green_name = var.tg_green_name

  ecs_cluster_name = var.ecs_cluster_name
  ecs_service_name = var.ecs_service_name
}
