variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

# SlackのURLがTerraform planやapply時にログに値が表示されないように保護
variable "slack_webhook_url" {
  description = "SlackのWebhook URL"
  type        = string
  sensitive   = true
}
