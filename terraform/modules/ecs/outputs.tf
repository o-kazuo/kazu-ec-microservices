output "cluster_id" {
  description = "ECSクラスターのID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECSクラスター名"
  value       = aws_ecs_cluster.main.name
}

output "task_execution_role_arn" {
  description = "タスク実行ロールのARN"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "タスクロールのARN"
  value       = aws_iam_role.ecs_task.arn
}

output "security_group_id" {
  description = "ECSセキュリティグループID"
  value       = aws_security_group.ecs.id
}

output "alb_arn" {
  description = "ALBのARN"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.main.dns_name
}

output "product_target_group_arn" {
  description = "product-serviceのターゲットグループARN"
  value       = aws_lb_target_group.product.arn
}

output "order_target_group_arn" {
  description = "order-serviceのターゲットグループARN"
  value       = aws_lb_target_group.order.arn
}

output "product_target_group_green_arn" {
  description = "product-serviceのGreenターゲットグループARN"
  value       = aws_lb_target_group.product_green.arn
}

output "order_target_group_green_arn" {
  description = "order-serviceのGreenターゲットグループARN"
  value       = aws_lb_target_group.order_green.arn
}

output "alb_listener_arn" {
  description = "ALBリスナーのARN"
  value       = aws_lb_listener.main.arn
}

