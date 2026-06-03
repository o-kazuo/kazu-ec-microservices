# ECRリポジトリ（サービスごとに作成）
resource "aws_ecr_repository" "main" {
  for_each = toset(var.services)

  name                 = "${var.project_name}-${var.environment}-${each.value}"
  image_tag_mutability = "MUTABLE"

  # イメージスキャン設定（push时に脆弱性スキャン）
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.value}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ECRライフサイクルポリシー（古いイメージを自動削除）
resource "aws_ecr_lifecycle_policy" "main" {
  for_each   = toset(var.services)
  repository = aws_ecr_repository.main[each.value].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "直近10個のイメージだけ残す"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
