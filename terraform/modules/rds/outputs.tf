output "cluster_endpoint" {
  description = "Auroraクラスターの書き込みエンドポイント"
  value       = aws_rds_cluster.main.endpoint
}

output "cluster_reader_endpoint" {
  description = "Auroraクラスターの読み取りエンドポイント"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "security_group_id" {
  description = "RDSセキュリティグループID"
  value       = aws_security_group.rds.id
}

output "secret_arn" {
  description = "DBパスワードのSecrets Manager ARN"
  value       = aws_secretsmanager_secret.db.arn
}
