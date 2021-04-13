################################
# IAM
################################
output "out_ecs_tasks_exec_iam_role_arn" {
  value = aws_iam_role.ecs_tasks_exec_iam_role_module.arn
}

output "out_ecs_tasks_exec_iam_role_attachments_arns" {
  value = [
    aws_iam_role_policy_attachment.ecs_tasks_exec_iam_policy_attachment_module.policy_arn,
    aws_iam_role_policy_attachment.ssm_parameter_read_iam_policy_attachment_module.policy_arn,
    aws_iam_role_policy_attachment.ecs_ssm_messages_iam_policy_attachment_module.policy_arn,
  ]
}


################################
# CloudWatch Log Group
################################
output "out_cloudwatch_logs_name" {
  value = aws_cloudwatch_log_group.ecs_cloudwatch_logs_module.name
}


################################
# ECS
################################
output "out_ecs_cluster_name" {
    value = aws_ecs_cluster.ecs_cluster_module.name
}


################################
# ALB
################################
output "out_alb_dns" {
    value = aws_lb.alb_module.dns_name
}
output "out_alb_tg_default_name" {
    value = aws_lb_target_group.alb_target_group_default_module.name
}

output "out_bg_alb_dns" {
  value = aws_lb.bg_alb_module.dns_name
}
output "out_bg_alb_arn" {
  value = aws_lb.bg_alb_module.arn
}
output "out_blue_listener_arn" {
  value = aws_lb_listener.alb_bg_first_listener_module.arn
}
output "out_green_listener_arn" {
  value = aws_lb_listener.alb_bg_second_listener_module.arn
}

output "out_alb_tg_blue_name" {
  value = aws_lb_target_group.alb_target_group_blue_module.name
}
output "out_alb_tg_green_name" {
  value = aws_lb_target_group.alb_target_group_green_module.name
}
