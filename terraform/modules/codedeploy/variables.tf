variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECSクラスター名"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALBリスナーのARN"
  type        = string
}

variable "product_target_group_arn" {
  description = "product-serviceのターゲットグループARN"
  type        = string
}

variable "order_target_group_arn" {
  description = "order-serviceのターゲットグループARN"
  type        = string
}

variable "product_target_group_green_arn" {
  description = "product-serviceのGreenターゲットグループARN"
  type        = string
}

variable "order_target_group_green_arn" {
  description = "order-serviceのGreenターゲットグループARN"
  type        = string
}

