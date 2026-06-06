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

