################################
# (Common)
################################
variable "region" {}
variable "account_id" {}

variable "environment_name" {}
variable "product_name" {}


################################
# ECS
################################
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}


################################
# ALB
################################
variable "alb_name" {}
variable "alb_default_target_name" {}
variable "certificate_arn" {}

variable "zone_id" {}
variable "dns_sub_domain" {}
variable "dns_cname_ttl" {}


################################
# etc
################################
## tags
variable "tags_env" {}

## external
variable "vpc_id" {}
variable "public_subnet_a_id" {}
variable "public_subnet_c_id" {}
variable "sg_public_id" {}
