# アカウントID取得
data "aws_caller_identity" "current" {}

# REST API
resource "aws_api_gateway_rest_api" "main" {
  name = "${var.project_name}-${var.environment}-api"

  tags = {
    Name        = "${var.project_name}-${var.environment}-api"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# VPC Link
resource "aws_api_gateway_vpc_link" "main" {
  name        = "${var.project_name}-${var.environment}-vpc-link"
  target_arns = [var.alb_arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc-link"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# デプロイ
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  depends_on = [aws_api_gateway_rest_api.main]
}

# ステージ
resource "aws_api_gateway_stage" "main" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  deployment_id = aws_api_gateway_deployment.main.id
  stage_name    = var.environment

  tags = {
    Name        = "${var.project_name}-${var.environment}-stage"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
