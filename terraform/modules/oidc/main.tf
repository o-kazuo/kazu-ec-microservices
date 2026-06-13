# OIDCプロバイダー
# url=Git HubのOIDCエンドポイントで証明書はここからくる
# Clieent_id_list=AWSのSTS(一時認証サービス)を使いAWSに対して認証する
# thumbprint=Git Hub証明の指紋(フィンガープリント)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# GitHub Actions用IAMロール
# OIDCトークンを使ってロールを引き受ける
# このリポジトリからのアクセスだけ許可(重要!)
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-github-actions-role"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# GitHub ActionsにECR・ECS・CodeDeployの権限を付与
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:GetApplicationRevision"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode"
        ]
        Resource = "*"
      }
    ]
  })
}
