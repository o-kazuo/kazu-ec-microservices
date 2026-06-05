variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

# これはVPC LINKのために必要
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

