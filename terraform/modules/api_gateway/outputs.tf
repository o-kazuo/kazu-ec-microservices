output "api_id" {
  description = "REST API ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_arn" {
  description = "REST APIのARN"
  value       = aws_api_gateway_rest_api.main.arn
}

output "stage_arn" {
  description = "ステージのARN"
  value       = "arn:aws:execute-api:ap-northeast-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.main.id}/${var.environment}"
}

output "invoke_url" {
  description = "APIのエンドポイントURL"
  value       = aws_api_gateway_stage.main.invoke_url
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = aws_api_gateway_vpc_link.main.id
}
