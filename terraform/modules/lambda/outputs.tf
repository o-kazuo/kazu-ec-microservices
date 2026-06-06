output "function_name" {
  description = "Lambda関数名"
  value       = aws_lambda_function.notification.function_name
}

output "function_arn" {
  description = "Lambda関数のARN"
  value       = aws_lambda_function.notification.arn
}
