################################
# ECR Repository
################################
module "maintenance" {
  source = "../../modules/around/containerRegistry"

  tags_env = "across"

  ecr_name = "codedeploy-practice/maintenance"

  num_untagged_images   = 1
  num_staging_images    = 3
  num_production_images = 5

  tagPrefixList_staging    = ["develop"]
  tagPrefixList_production = ["main"]
}
