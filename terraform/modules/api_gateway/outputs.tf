output "api_endpoint" {
  description = "API GatewayのエンドポイントURL"
  value       = aws_apigatewayv2_stage.main.invoke_url
}

output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.main.id
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = aws_apigatewayv2_vpc_link.main.id
}

output "api_arn" {
  description = "API GatewayのARN"
  value       = aws_apigatewayv2_api.main.arn
}

output "stage_arn" {
  description = "API GatewayステージのARN"
  value       = "arn:aws:apigateway:ap-northeast-1::/apis/${aws_apigatewayv2_api.main.id}/stages/${var.environment}"
}

