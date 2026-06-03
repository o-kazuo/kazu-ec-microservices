variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "services" {
  description = "ECRリポジトリを作成するサービス名リスト"
  type        = list(string)
  default     = ["product", "order", "notification"]
}
