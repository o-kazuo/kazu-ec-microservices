#!/bin/bash

echo "=== terraform destroy 開始 ==="
cd ~/kazu-ec-microservices/terraform/environments/dev
terraform destroy -auto-approve

echo "=== 完了 ==="
