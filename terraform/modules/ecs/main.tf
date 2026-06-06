# ECSクラスター
# コンテナを動かす「土地」作り
# containerInsight = "enable"
# CloudWatchと連携してコンテナのCPU/メモリ/ネットワークを監視できるようにする設定
# 監視・運用のポイント

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ECSタスク実行IAMロール
# タスクがECRからイメージを取得したり、CloudWatchにログを送るために必要
# ECRからDockerイメージを取得
# CloudWatch Logsにログを送る

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# タスク実行ロールに必要な権限をアタッチ
# これはタスクロールとは別で、アプリ(FastAPI)実行中にAWSサービスにアクセスするための権限
# 例：SQS・DynamoDB・Secrets Managerへのアクセスなど

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスクIAMロール
# タスク内のアプリがAWSサービスにアクセスするために必要
resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# セキュリティグループ（ECS用）
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # アウトバウンド（外への通信）は全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-sg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# SQSアクセスポリシー(SQSにメッセージを送る権限)
resource "aws_iam_role_policy" "ecs_sqs" {
  name = "${var.project_name}-${var.environment}-ecs-sqs-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]
        Resource = var.sqs_queue_arn
      }
    ]
  })
}

# SecretsManagerアクセスポリシー(SecretsManagerからパスワードを取得する権限)
resource "aws_iam_role_policy" "ecs_secrets" {
  name = "${var.project_name}-${var.environment}-ecs-secrets-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.db_secret_arn
      }
    ]
  })
}

# X-Rayアクセスポリシー(X-Rayにトレースを送る権限)
resource "aws_iam_role_policy_attachment" "ecs_xray" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = var.xray_policy_arn
}

# ALB(ECS用のALBの作成)
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs.id]
  subnets            = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ターゲットグループ（product-service）
resource "aws_lb_target_group" "product" {
  name        = "${var.project_name}-${var.environment}-product-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-product-tg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ターゲットグループ（order-service）
resource "aws_lb_target_group" "order" {
  name        = "${var.project_name}-${var.environment}-order-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-order-tg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ALBリスナー
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.product.arn
  }
}

# タスク定義（product-service）
resource "aws_ecs_task_definition" "product" {
  family                   = "${var.project_name}-${var.environment}-product"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "product"
      image = "${var.ecr_product_image_uri}:latest"
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-${var.environment}-product"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-product"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# タスク定義（order-service）
resource "aws_ecs_task_definition" "order" {
  family                   = "${var.project_name}-${var.environment}-order"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "order"
      image = "${var.ecr_order_image_uri}:latest"
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-${var.environment}-order"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-order"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ECSサービス（product-service）
resource "aws_ecs_service" "product" {
  name            = "${var.project_name}-${var.environment}-product-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.product.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.product.arn
    container_name   = "product"
    container_port   = 8000
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-product-service"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ECSサービス（order-service）
resource "aws_ecs_service" "order" {
  name            = "${var.project_name}-${var.environment}-order-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.order.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.order.arn
    container_name   = "order"
    container_port   = 8000
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-order-service"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}