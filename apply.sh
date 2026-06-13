#!/bin/bash

# Slack Webhook URLをAWS Parameter Storeから取得（SecureStringで暗号化保存）
echo "=== Slack Webhook URLをParameter Storeから取得 ==="
export TF_VAR_slack_webhook_url=$(aws ssm get-parameter \
  --name "/kazu-ec/dev/slack-webhook-url" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region ap-northeast-1)

echo "=== terraform apply 開始 ==="
cd ~/kazu-ec-microservices/terraform/environments/dev
terraform init

echo "=== Phase1: CodeDeploy・Lambda以外のリソースを作成 ==="
terraform apply -auto-approve \
  -target=module.vpc \
  -target=module.ecs \
  -target=module.ecr \
  -target=module.rds \
  -target=module.dynamodb \
  -target=module.sqs \
  -target=module.api_gateway \
  -target=module.cloudwatch \
  -target=module.waf \
  -target=module.xray \
  -target=module.oidc

echo "=== GitHub SecretsにARNを登録 ==="
ROLE_ARN=$(terraform output -raw github_actions_role_arn)
gh secret set AWS_ROLE_ARN --body "$ROLE_ARN" --repo o-kazuo/kazu-ec-microservices

echo "=== Phase1完了 ==="
echo "次にGitHub ActionsでECRにイメージをpushしてください"
echo "その後 ./apply_phase2.sh を実行してください"
echo "AWS_ROLE_ARN: $ROLE_ARN"