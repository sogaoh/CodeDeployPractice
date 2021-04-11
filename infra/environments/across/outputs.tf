################################
# ECR Repository
################################
output "maintenance_ecr_repository_url" {
  value = module.maintenance.out_ecr_repository_url
}


################################
# ACM Certificate
################################
//output "out_development-acm_certificate_arn" {
//  value = module.dev-codedeploy-practice_ant-in-giant_dev_certificate.out_acm_certificate_arn
//}
