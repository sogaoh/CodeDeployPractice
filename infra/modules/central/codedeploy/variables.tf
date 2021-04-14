################################
# (Common)
################################
variable "account_id" {}
variable "environment_name" {}
variable "product_name" {}


################################
# CodeDeploy
################################
variable "code_deploy_app_name" {}
variable "code_deploy_group_name" {}


################################
# etc
################################
## tags
variable "tags_env" {}

## external
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "alb_primary_listener_arn" {}
variable "alb_secondary_listener_arn" {}
variable "target_group_blue_name" {}
variable "target_group_green_name" {}
