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
