output "xray_policy_arn" {
  description = "X-RayポリシーのARN"
  value       = aws_iam_policy.xray.arn
}
