################################
# ECR Repository
# @see https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
################################
resource "aws_ecr_repository" "ecr_module" {
  name = var.ecr_name

  # タグのイミュータビリティ
  image_tag_mutability = "MUTABLE"

  # プッシュ時にスキャン
  image_scanning_configuration {
    scan_on_push = false
  }

  # 暗号化タイプ
  encryption_configuration {
    encryption_type = "AES256"
  }

  # Tags
  tags = {
    Name = var.ecr_name
    Env  = var.tags_env
  }
}


################################
# ECR Lifecycle Policy
# @see https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy
################################
resource "aws_ecr_lifecycle_policy" "ecr_lifecyclec_policy_module" {
  repository = aws_ecr_repository.ecr_module.name

  policy = jsonencode(
  {
    rules = [
      {
        description = "Hold only ${var.num_untagged_images} untagged image"
        action = {
          type = "expire"
        }
        rulePriority = 1
        selection = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = var.num_untagged_images
        }
      },
      {
        description = "Hold only ${var.num_production_images} release (production) tagged image"
        action = {
          type = "expire"
        }
        rulePriority = 10
        selection = {
          tagStatus = "tagged"
          tagPrefixList = var.tagPrefixList_production,
          countType = "imageCountMoreThan"
          countNumber = var.num_production_images
        }
      },
      {
        description = "Hold only ${var.num_staging_images} develop (staging) tagged image"
        action = {
          type = "expire"
        }
        rulePriority = 20
        selection = {
          tagStatus = "tagged"
          tagPrefixList = var.tagPrefixList_staging,
          countType = "imageCountMoreThan"
          countNumber = var.num_staging_images
        }
      },
    ]
  }
  )
}
