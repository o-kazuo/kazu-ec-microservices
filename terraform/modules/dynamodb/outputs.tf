output "notification_history_table_name" {
  description = "通知履歴テーブル名"
  value       = aws_dynamodb_table.notification_history.name
}

output "notification_history_table_arn" {
  description = "通知履歴テーブルのARN"
  value       = aws_dynamodb_table.notification_history.arn
}
