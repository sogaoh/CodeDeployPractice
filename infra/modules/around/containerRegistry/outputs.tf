################################
# ECR Repository
################################
output "out_ecr_repository_url" {
  value = aws_ecr_repository.ecr_module.repository_url
}

################################
# ECR Lifecycle Policy
################################
