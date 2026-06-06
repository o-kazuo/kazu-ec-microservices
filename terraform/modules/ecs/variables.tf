variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sqs_queue_arn" {
  description = "SQSキューのARN"
  type        = string
}

variable "db_secret_arn" {
  description = "DBパスワードのSecrets Manager ARN"
  type        = string
}

variable "xray_policy_arn" {
  description = "X-RayポリシーのARN"
  type        = string
}

variable "private_subnet_ids" {
  description = "プライベートサブネットIDリスト"
  type        = list(string)
}

variable "ecr_product_image_uri" {
  description = "product-serviceのECRイメージURI"
  type        = string
}

variable "ecr_order_image_uri" {
  description = "order-serviceのECRイメージURI"
  type        = string
}

