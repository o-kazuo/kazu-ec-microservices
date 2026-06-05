# デッドレターキュー（処理失敗したメッセージを保管）
resource "aws_sqs_queue" "dlq" {
  name                      = "${var.project_name}-${var.environment}-dlq"
  message_retention_seconds = 1209600  # 14日間保管

  tags = {
    Name        = "${var.project_name}-${var.environment}-dlq"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# メインキュー
resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-order-queue"
  message_retention_seconds  = 86400  # 1日間保管
  visibility_timeout_seconds = 30

  # デッドレターキューの設定
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-order-queue"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
