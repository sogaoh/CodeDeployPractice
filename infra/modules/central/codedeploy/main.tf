# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group

################################
# CodeDeploy
################################
resource "aws_codedeploy_app" "code_deploy_app_module" {
  compute_platform = "ECS"
  name             = var.code_deploy_app_name
}

resource "aws_codedeploy_deployment_group" "code_deploy_group_module" {
  app_name               = aws_codedeploy_app.code_deploy_app_module.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = var.code_deploy_group_name
  service_role_arn       = aws_iam_role.code_deploy_iam_role_module.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 6
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.alb_primary_listener_arn
      }

      test_traffic_route {
        listener_arns = var.alb_secondary_listener_arn
      }

      target_group {
        name = var.target_group_blue_name
      }

      target_group {
        name = var.target_group_green_name
      }
    }
  }
}


# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

################################
# IAM
################################
resource "aws_iam_role" "code_deploy_iam_role_module" {
  name = "${var.environment_name}-${var.product_name}-code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_iam_policy_module.json

  tags = {
    Name = "${var.environment_name}-${var.product_name}-code-deploy-role"
    Env = var.tags_env
  }
}

data "aws_iam_policy_document" "code_deploy_iam_policy_module" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "code_deploy_iam_policy_attachment_module" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy_iam_role_module.name
}


# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/userguide/deployment-type-bluegreen.html#deployment-type-bluegreen-IAM
# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs_managed_policies.html
# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/codedeploy_IAM_role.html
# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/deployment-type-bluegreen.html#deployment-type-bluegreen-IAM
resource "aws_iam_policy" "blue_green_deploy_iam_policy_module" {
  name = "${var.environment_name}-${var.product_name}-blue_green_deploy-policy"
  policy = data.aws_iam_policy_document.blue_green_deploy_iam_policy_document_module.json
}

data "aws_iam_policy_document" "blue_green_deploy_iam_policy_document_module" {
  # *-ecs-task-execution-role
  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:role/*-${var.product_name}-ecs-task-execution-role"
    ]
  }

  # AmazonECS_FullAccess
  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:DescribeScalingActivities",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:RegisterScalableTarget",
      "appmesh:ListMeshes",
      "appmesh:ListVirtualNodes",
      "appmesh:DescribeVirtualNode",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:Describe*",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStack*",
      "cloudformation:UpdateStack",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:PutMetricAlarm",
      "codedeploy:CreateApplication",
      "codedeploy:CreateDeployment",
      "codedeploy:CreateDeploymentGroup",
      "codedeploy:GetApplication",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentGroup",
      "codedeploy:ListApplications",
      "codedeploy:ListDeploymentGroups",
      "codedeploy:ListDeployments",
      "codedeploy:StopDeployment",
      "codedeploy:GetDeploymentTarget",
      "codedeploy:ListDeploymentTargets",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision",
      "codedeploy:BatchGetApplicationRevisions",
      "codedeploy:BatchGetDeploymentGroups",
      "codedeploy:BatchGetDeployments",
      "codedeploy:BatchGetApplications",
      "codedeploy:ListApplicationRevisions",
      "codedeploy:ListDeploymentConfigs",
      "codedeploy:ContinueDeployment",
      "sns:ListTopics",
      "lambda:ListFunctions",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotFleetRequests",
      "ec2:CreateInternetGateway",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteSubnet",
      "ec2:DeleteVpc",
      "ec2:Describe*",
      "ec2:DetachInternetGateway",
      "ec2:DisassociateRouteTable",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:RunInstances",
      "ec2:RequestSpotFleet",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "ecs:*",
      "events:DescribeRule",
      "events:DeleteRule",
      "events:ListRuleNamesByTarget",
      "events:ListTargetsByRule",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents",
      "route53:GetHostedZone",
      "route53:ListHostedZonesByName",
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:GetHealthCheck",
      "servicediscovery:CreatePrivateDnsNamespace",
      "servicediscovery:CreateService",
      "servicediscovery:GetNamespace",
      "servicediscovery:GetOperation",
      "servicediscovery:GetService",
      "servicediscovery:ListNamespaces",
      "servicediscovery:ListServices",
      "servicediscovery:UpdateService",
      "servicediscovery:DeleteService"
    ]

    resources = [
      "*"
    ]
  }

  # AWSCodeDeployRoleForECS
  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
      "lambda:InvokeFunction",
      "cloudwatch:DescribeAlarms",
      "sns:Publish",
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]

    condition {
      test = "StringLike"
      values = [
        "ecs-tasks.amazonaws.com"
      ]
      variable = "iam:PassedToService"
    }
  }


}

resource "aws_iam_role_policy_attachment" "blue_green_deploy_iam_policy_attachment_module" {
  role = aws_iam_role.code_deploy_iam_role_module.name
  policy_arn = aws_iam_policy.blue_green_deploy_iam_policy_module.arn
}
