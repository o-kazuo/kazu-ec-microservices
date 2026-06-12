variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "github_org" {
  description = "GitHubのorganization名またはユーザー名"
  type        = string
  default     = "o-kazuo"
}

variable "github_repo" {
  description = "GitHubのリポジトリ名"
  type        = string
  default     = "kazu-ec-microservices"
}
