output "repository_urls" {
  description = "ECRリポジトリのURL一覧"
  value       = { for k, v in aws_ecr_repository.main : k => v.repository_url }
}

output "repository_arns" {
  description = "ECRリポジトリのARN一覧"
  value       = { for k, v in aws_ecr_repository.main : k => v.arn }
}
