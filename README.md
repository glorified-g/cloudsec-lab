# cloudsec-lab

Public CloudSec / CNAPP lab: GitHub Actions → Terraform → AWS (ECR/ECS), plus Trivy, Gitleaks, and Prowler.

The app is intentionally boring. Infrastructure and security controls are the product.

## Local (Phase 1)

```bash
cd app
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open http://localhost:8080 — health check: http://localhost:8080/health

## Docker (Phase 2)

```bash
# Stop the local `python app.py` first (Ctrl+C) so port 8080 is free.
docker build -t cloudsec-lab .
docker run --rm -p 8080:8080 cloudsec-lab
```

Open http://localhost:8080 — Environment should say **docker**. Health: http://localhost:8080/health

```bash
docker stop cloudsec-lab
```

## AWS (Phase 3) — Fargate, no ALB

Smallest bill: 0.25 vCPU / 512 MB, public subnet + public IP (no NAT, no ALB). **Scale to 0 or destroy when you close the laptop.**

```bash
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE=ken-lab
cd terraform
terraform init
terraform plan
terraform apply
# then push image (below), then:
terraform apply -var='desired_count=1'
```

Push the local image (after apply creates ECR):

```bash
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE=ken-lab
# from repo root
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com"
docker tag cloudsec-lab:latest "$(terraform -chdir=terraform output -raw ecr_repository_url):latest"
docker push "$(terraform -chdir=terraform output -raw ecr_repository_url):latest"
chmod +x scripts/ecs-url.sh
./scripts/ecs-url.sh
```

If the service started before the push, force a new deployment:

```bash
aws ecs update-service --cluster cloudsec-lab --service cloudsec-lab --force-new-deployment --profile ken-lab
```

Stop billing (keeps VPC/ECR):

```bash
cd terraform && terraform apply -auto-approve -var='desired_count=0'
```

Full teardown: `terraform destroy`


