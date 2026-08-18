# Scale Fargate up / down (Mac CLI)

Start or stop the ECS service from the Mac. **This is Terraform on `ken-lab`, not GitHub Actions.** No workflow will run.

Scale to **0** when you close the laptop. The public IP is new every start. VPC, ECR, and OIDC stay.

## Env (each terminal)

```bash
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE=ken-lab
cd /Users/glo/repos/cloudsec-lab/terraform
```

Pass **`image_tag` to match the running task definition**. After the Actions `ecr-push` image, that is `gha`. If you omit it, Terraform’s default `latest` will try to change the task image as well as the count.

## Scale up

```bash
terraform apply -var='desired_count=1' -var='image_tag=gha'
```

Type `yes`. Plan should be **only** `desired_count`: 0 → 1. If it also wants to replace the task definition, stop and fix `image_tag`.

Wait ~30–60s:

```bash
aws ecs describe-services --cluster cloudsec-lab --services cloudsec-lab \
  --query 'services[0].{desired:desiredCount,running:runningCount}' --output table
```

When **running = 1**:

```bash
../scripts/ecs-url.sh
```

Open the `http://…:8080` URL. `/health` should be `{"status":"healthy"}`. Environment on the page: **aws**.

## Scale down

Same terminal, same `image_tag`:

```bash
terraform apply -auto-approve -var='desired_count=0' -var='image_tag=gha'
```

```bash
aws ecs describe-services --cluster cloudsec-lab --services cloudsec-lab \
  --query 'services[0].{desired:desiredCount,running:runningCount}' --output table
```

Done when **desired 0 / running 0**. The old URL may still answer for a few seconds, then connection refused.

## Notes

- `destroy` is not this procedure — that deletes the VPC/ECR/OIDC too.
- Changing only `desired_count` in AWS Console (or `aws ecs update-service`) will **drift**; the next apply sets it back to whatever you pass here. That is intentional in this lab. See the README (Terraform vs live ECS fields).
