# kazu-ec-microservices

ECサイト型マイクロサービス基盤 on AWS

## 概要

マイクロサービスアーキテクチャを用いたECサイト基盤です。
「監視・運用自動化」「CI/CD強化」「セキュリティ完全実装」をテーマに構築しています。

## アーキテクチャ

\`\`\`
フロントエンド（Streamlit）
    ↓
API Gateway（同期通信）
    ↓
商品サービス ←→ 注文サービス
    ↓
SQS（非同期通信）
    ↓
通知サービス（Lambda）
    ↓
SNS → Slack / メール
\`\`\`

## マイクロサービス構成

| サービス | 技術スタック | 役割 |
|---|---|---|
| product-service | ECS Fargate + FastAPI + Aurora MySQL | 商品一覧・検索・在庫管理 |
| order-service | ECS Fargate + FastAPI + Aurora MySQL | 注文受付・ステータス管理 |
| notification-service | Lambda + SES/SNS + DynamoDB | 注文確認メール・Slack通知 |

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| フロントエンド | Streamlit（Python） |
| バックエンド | FastAPI（ECS Fargate） |
| DB | Aurora MySQL + DynamoDB |
| 認証 | Auth0 |
| CI/CD | GitHub Actions + CodeDeploy（Blue/Green）+ Trivy |
| セキュリティ | IAM最小権限・KMS・WAF・Secrets Manager・GuardDuty |
| 監視 | CloudWatch + X-Ray + CloudTrail + EventBridge |
| IaC | Terraform（モジュール構成） |

## ディレクトリ構成

\`\`\`
kazu-ec-microservices/
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ecs/
│   │   ├── rds/
│   │   ├── dynamodb/
│   │   ├── sqs/
│   │   ├── api_gateway/
│   │   ├── lambda/
│   │   ├── cloudwatch/
│   │   ├── xray/
│   │   ├── waf/
│   │   └── codedeploy/
│   └── environments/
│       └── dev/
├── services/
│   ├── product/
│   ├── order/
│   └── notification/
├── frontend/
├── .github/
│   └── workflows/
│       ├── product-service.yml
│       ├── order-service.yml
│       └── notification-service.yml
└── README.md
\`\`\`

## 保有資格

- AWS CLF（856点）
- AWS SAA（832点）
