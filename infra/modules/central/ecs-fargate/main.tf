# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

################################
# IAM
################################
resource "aws_iam_role" "ecs_tasks_exec_iam_role_module" {
  name = "${var.environment_name}-${var.product_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_exec_iam_policy_module.json

  tags = {
    Name = "${var.environment_name}-${var.product_name}-ecs-task-execution-role"
    Env = var.tags_env
  }
}

data "aws_iam_policy_document" "ecs_tasks_exec_iam_policy_module" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_exec_iam_policy_attachment_module" {
  role = aws_iam_role.ecs_tasks_exec_iam_role_module.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy_attachment" "ssm_parameter_read_iam_policy_attachment_module" {
  role       = aws_iam_role.ecs_tasks_exec_iam_role_module.name
  policy_arn = aws_iam_policy.ssm_parameter_read_iam_policy_module.arn
}

resource "aws_iam_policy" "ssm_parameter_read_iam_policy_module" {
  name   = "${var.environment_name}-${var.product_name}-ssm-parameter-read-policy"
  policy = data.aws_iam_policy_document.ssm_parameter_read_iam_policy_document_module.json
}

data "aws_iam_policy_document" "ssm_parameter_read_iam_policy_document_module" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.tags_env}/${var.product_name}/${var.ecs_service_name}/*"
    ]
  }
}


#################################### ↓for ECS Exec
# https://aws.amazon.com/jp/blogs/news/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/
resource "aws_iam_policy" "ecs_ssm_messages_iam_policy_module" {
  name = "${var.environment_name}-${var.product_name}-ecs-ssm_messages-policy"
  policy = data.aws_iam_policy_document.ecs_ssm_messages_iam_policy_document_module.json
}

data "aws_iam_policy_document" "ecs_ssm_messages_iam_policy_document_module" {
  statement {
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_messages_iam_policy_attachment_module" {
  role = aws_iam_role.ecs_tasks_exec_iam_role_module.name
  policy_arn = aws_iam_policy.ecs_ssm_messages_iam_policy_module.arn
}
#################################### ↑for ECS Exec


# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group

################################
# CloudWatch Log Group
################################
resource "aws_cloudwatch_log_group" "ecs_cloudwatch_logs_module" {
  name = "/ecs/${var.environment_name}-${var.product_name}/${var.ecs_service_name}"

  tags = {
    Name = "/ecs/${var.environment_name}-${var.product_name}/${var.ecs_service_name}"
    Env = var.tags_env
  }
}


# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster

################################
# ECS Cluster
################################
resource "aws_ecs_cluster" "ecs_cluster_module" {
  name = var.ecs_cluster_name

  setting {
    name = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = var.ecs_cluster_name
    Env = var.tags_env
  }
}


# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

################################
# ALB
################################
resource "aws_lb" "alb_module" {
  load_balancer_type = "application"
  name = var.alb_name

  security_groups = [
    var.sg_public_id
  ]
  subnets = [
    var.public_subnet_a_id,
    var.public_subnet_c_id,
  ]

  tags = {
    Name = var.alb_name
    Env = var.tags_env
  }
}

resource "aws_lb_listener" "alb_80_listener_module" {
  load_balancer_arn = aws_lb.alb_module.id

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  port = 80
  protocol = "HTTP"
}

resource "aws_lb_listener" "alb_443_listener_module" {
  load_balancer_arn = aws_lb.alb_module.id

  ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group_default_module.arn
    type = "forward"
  }

  port = 443
  protocol = "HTTPS"
}


resource "aws_lb_target_group" "alb_target_group_default_module" {
  name = var.alb_default_target_name

  vpc_id = var.vpc_id

  target_type = "ip"

  port = 80
  protocol = "HTTP"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = 200
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.alb_default_target_name
    Env = var.tags_env
  }
}


resource "aws_route53_record" "route53_CNAME_module" {
  zone_id = var.zone_id
  name    = var.dns_sub_domain
  ttl     = var.dns_cname_ttl
  type    = "CNAME"
  records = [
    aws_lb.alb_module.dns_name,
  ]
}
