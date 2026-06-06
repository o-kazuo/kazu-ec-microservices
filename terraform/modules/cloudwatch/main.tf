# SNSトピック（アラーム通知用）
resource "aws_sns_topic" "alarm" {
  name = "${var.project_name}-${var.environment}-alarm"

  tags = {
    Name        = "${var.project_name}-${var.environment}-alarm"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ECSロググループ(7日だけ保護でコスト抑制)
resource "aws_cloudwatch_log_group" "ecs_product" {
  name              = "/ecs/${var.project_name}-${var.environment}-product"
  retention_in_days = 7

  tags = {
    Name        = "/ecs/${var.project_name}-${var.environment}-product"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_order" {
  name              = "/ecs/${var.project_name}-${var.environment}-order"
  retention_in_days = 7

  tags = {
    Name        = "/ecs/${var.project_name}-${var.environment}-order"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Lambdaロググループ
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-notification"
  retention_in_days = 7

  tags = {
    Name        = "/aws/lambda/${var.project_name}-${var.environment}-notification"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# CPUアラーム（product-service）
# ECSのCPU使用率が80%を超えたらSNSに通知(2回連続で超えたら発火・60秒ごとにチェック)
resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [aws_sns_topic.alarm.arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-cpu"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

