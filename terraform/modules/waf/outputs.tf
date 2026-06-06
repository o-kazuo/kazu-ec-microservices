output "web_acl_arn" {
  description = "WAF Web ACLのARN"
  value       = aws_wafv2_web_acl.main.arn
}
