# X-Ray用IAMポリシー
resource "aws_iam_policy" "xray" {
  name        = "${var.project_name}-${var.environment}-xray-policy"
  description = "X-Rayにトレースを送信するポリシー"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-xray-policy"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# X-Ray暗号化設定(本番ではtype=KMSで暗号化)
resource "aws_xray_encryption_config" "main" {
  type = "NONE"
}
