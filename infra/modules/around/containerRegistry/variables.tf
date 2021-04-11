variable "tags_env" {}

################################
# ECR Repository
################################
variable "ecr_name" {}

################################
# ECR Lifecycle Policy
################################
variable "num_untagged_images" {}
variable "num_production_images" {}
variable "tagPrefixList_production" {}
variable "num_staging_images" {}
variable "tagPrefixList_staging" {}
