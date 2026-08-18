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
