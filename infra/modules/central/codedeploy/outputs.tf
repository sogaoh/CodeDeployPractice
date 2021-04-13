################################
# CodeDeploy
################################
output "out_code_deploy_application_name" {
  value = aws_codedeploy_app.code_deploy_app_module.name
}


################################
# IAM
################################
output "out_code_deploy_iam_role_arn" {
  value = aws_iam_role.code_deploy_iam_role_module.arn
}

output "out_code_deploy_iam_role_attachments_arns" {
  value = [
    aws_iam_role_policy_attachment.code_deploy_iam_policy_attachment_module.policy_arn,
  ]
}
