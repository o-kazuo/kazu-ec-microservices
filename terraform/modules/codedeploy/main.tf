# CodeDeploy用IAMロール(ECSへのデプロイ権限が付与される)
resource "aws_iam_role" "codedeploy" {
  name = "${var.project_name}-${var.environment}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-codedeploy-role"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# CodeDeployポリシーアタッチ
resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# CodeDeployアプリケーション（product-service）アプリがECSで動くという定義
resource "aws_codedeploy_app" "product" {
  name             = "${var.project_name}-${var.environment}-product"
  compute_platform = "ECS"
}

# CodeDeployアプリケーション（order-service）
resource "aws_codedeploy_app" "order" {
  name             = "${var.project_name}-${var.environment}-order"
  compute_platform = "ECS"
}

# デプロイグループ（product-service）
resource "aws_codedeploy_deployment_group" "product" {
  app_name               = aws_codedeploy_app.product.name
  deployment_group_name  = "${var.project_name}-${var.environment}-product-dg"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = "${var.project_name}-${var.environment}-product-service"
  }

# Blue/Greenデプロイの設定
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }
      target_group {
        name = split("/", var.product_target_group_arn)[1]
      }
      target_group {
        name = split("/", var.product_target_group_arn)[1]
      }
    }
  }

# Greenが起動したら自動で切り替える(手動承認不要)
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    # デプロイ成功後5分待ってからBlueを削除(5分間は問題があればBlueに戻せる)
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

# デプロイ失敗時に自動でロールバック
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-product-dg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# デプロイグループ（order-service）
resource "aws_codedeploy_deployment_group" "order" {
  app_name               = aws_codedeploy_app.order.name
  deployment_group_name  = "${var.project_name}-${var.environment}-order-dg"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = "${var.project_name}-${var.environment}-order-service"
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }
      target_group {
        name = split("/", var.order_target_group_arn)[1]
      }
      target_group {
        name = split("/", var.order_target_group_arn)[1]
      }
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-order-dg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
