variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "sqs_queue_arn" {
  description = "SQSキューのARN"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "DynamoDBテーブルのARN"
  type        = string
}
