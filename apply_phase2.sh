#!/bin/bash
echo "=== Phase2: CodeDeploy・Lambdaを作成 ==="
cd ~/kazu-ec-microservices/terraform/environments/dev
terraform apply -auto-approve \
  -target=module.codedeploy
echo "=== 全リソース作成完了 ==="

