output "api_id" {
  description = "HTTP API ID"
  value       = aws_apigatewayv2_api.main.id
}

output "api_endpoint" {
  description = "HTTPAPIのエンドポイントURL"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "stage_arn" {
  description = "ステージのARN"
  value       = aws_apigatewayv2_stage.main.arn
}

output "invoke_url" {
  description = "APIの呼び出しURL"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/${var.environment}"
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = aws_apigatewayv2_vpc_link.main.id
}

