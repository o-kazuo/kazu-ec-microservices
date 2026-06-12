#!/bin/bash

echo "=== terraform apply 開始 ==="
cd ~/kazu-ec-microservices/terraform/environments/dev
terraform init
terraform apply -auto-approve

echo "=== GitHub SecretsにARNを登録 ==="
ROLE_ARN=$(terraform output -raw github_actions_role_arn)
gh secret set AWS_ROLE_ARN --body "$ROLE_ARN" --repo o-kazuo/kazu-ec-microservices

echo "=== 完了 ==="
echo "AWS_ROLE_ARN: $ROLE_ARN"
