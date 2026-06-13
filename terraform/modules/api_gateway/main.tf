# アカウントID取得
data "aws_caller_identity" "current" {}

# HTTP API (v2)
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-${var.environment}-api"
  protocol_type = "HTTP"

  tags = {
    Name        = "${var.project_name}-${var.environment}-api"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# VPC Link (v2)
resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.project_name}-${var.environment}-vpc-link"
  security_group_ids = [var.ecs_security_group_id]
  subnet_ids         = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc-link"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ステージ
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-stage"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Integration（HTTP API → VPC Link → ALB → ECS）
resource "aws_apigatewayv2_integration" "main" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.alb_listener_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
}

# Route（product）
resource "aws_apigatewayv2_route" "product" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /products/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# Route（order）
resource "aws_apigatewayv2_route" "order" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /orders/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# Route（notification）
resource "aws_apigatewayv2_route" "notification" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /notifications/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}