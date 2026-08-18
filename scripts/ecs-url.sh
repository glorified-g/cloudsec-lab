#!/usr/bin/env bash
# Print the running Fargate task public IP (no ALB in Phase 3).
set -euo pipefail
export AWS_PROFILE="${AWS_PROFILE:-ken-lab}"
CLUSTER="${CLUSTER:-cloudsec-lab}"
SERVICE="${SERVICE:-cloudsec-lab}"

TASK=$(aws ecs list-tasks --cluster "$CLUSTER" --service-name "$SERVICE" --desired-status RUNNING --query 'taskArns[0]' --output text)
if [[ "$TASK" == "None" || -z "$TASK" ]]; then
  echo "No running tasks. Is desired_count=1?" >&2
  exit 1
fi

ENI=$(aws ecs describe-tasks --cluster "$CLUSTER" --tasks "$TASK" --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text)
IP=$(aws ec2 describe-network-interfaces --network-interface-ids "$ENI" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
echo "http://${IP}:8080"
echo "http://${IP}:8080/health"
