output "github_actions_role_arn" {
  description = "GitHub Actions用IAMロールのARN"
  value       = module.oidc.github_actions_role_arn
}
