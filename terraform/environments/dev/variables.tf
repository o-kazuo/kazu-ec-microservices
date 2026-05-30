variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
  default     = "kazu-ec"
}

variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
}
