variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "ecs_security_group_id" {
  description = "ECSセキュリティグループID（VPC Linkが使用）"
  type        = string
}

variable "private_subnet_ids" {
  description = "プライベートサブネットIDリスト"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ALBリスナーのARN（Integrationのuri）"
  type        = string
}

