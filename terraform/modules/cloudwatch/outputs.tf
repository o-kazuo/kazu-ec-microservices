output "sns_topic_arn" {
  description = "SNSトピックのARN"
  value       = aws_sns_topic.alarm.arn
}

output "log_group_ecs_product" {
  description = "ECS productロググループ名"
  value       = aws_cloudwatch_log_group.ecs_product.name
}

output "log_group_ecs_order" {
  description = "ECS orderロググループ名"
  value       = aws_cloudwatch_log_group.ecs_order.name
}

output "log_group_lambda" {
  description = "Lambdaロググループ名"
  value       = aws_cloudwatch_log_group.lambda.name
}
