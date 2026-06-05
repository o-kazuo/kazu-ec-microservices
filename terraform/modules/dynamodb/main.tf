# 通知履歴テーブル
resource "aws_dynamodb_table" "notification_history" {
  name         = "${var.project_name}-${var.environment}-notification-history"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-notification-history"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
