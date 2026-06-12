output "github_actions_role_arn" {
  description = "GitHub Actions用IAMロールのARN"
  value       = aws_iam_role.github_actions.arn
}
