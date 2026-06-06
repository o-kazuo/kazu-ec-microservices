output "codedeploy_role_arn" {
  description = "CodeDeployのIAMロールARN"
  value       = aws_iam_role.codedeploy.arn
}

output "product_app_name" {
  description = "product-serviceのCodeDeployアプリ名"
  value       = aws_codedeploy_app.product.name
}

output "order_app_name" {
  description = "order-serviceのCodeDeployアプリ名"
  value       = aws_codedeploy_app.order.name
}

output "product_deployment_group_name" {
  description = "product-serviceのデプロイグループ名"
  value       = aws_codedeploy_deployment_group.product.deployment_group_name
}

output "order_deployment_group_name" {
  description = "order-serviceのデプロイグループ名"
  value       = aws_codedeploy_deployment_group.order.deployment_group_name
}
