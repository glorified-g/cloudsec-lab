# Security scans (Trivy + Gitleaks)

Same tools you ran on the Mac, in GitHub Actions.

| Scan | Where | Fails the job? |
|------|--------|----------------|
| Gitleaks | `security.yml` | Yes, if a secret is in git |
| Trivy filesystem | `security.yml` | Yes, HIGH/CRITICAL in app deps (`requirements.txt` was 0) |
| Trivy IaC | `infra.yml` | Yes, HIGH/CRITICAL **except** IDs in `.trivyignore` |
| Trivy image (libraries) | `deploy.yml` after push | Yes, HIGH/CRITICAL in Flask/pip packages |
| Trivy image (OS) | `deploy.yml` after push | No — Debian in `python:3.12-slim` currently has ~26 HIGH/CRITICAL; report only |

Image scan must `docker pull --platform linux/arm64` then `trivy image --platform linux/arm64`. Buildx pushes ARM64 only (Fargate); GitHub-hosted runners are amd64. Without `--platform`, Trivy looks for linux/amd64 and the job dies even though `:gha` is in ECR.

`.trivyignore` skips three Terraform findings we are keeping on purpose:

- **AVD-AWS-0031** — ECR tag mutability. `:gha` is overwritten by CI.
- **AVD-AWS-0104** — SG egress `0.0.0.0/0`. No NAT; the task has to reach ECR/logs.
- **AVD-AWS-0164** — public subnet `map_public_ip_on_launch`. No ALB.

`app/.venv` is in `.dockerignore` so the Mac venv is not copied into the image.

Ruleset **`main-protect`** is Active on the default branch: force-push and deleting `main` are blocked. Required status checks are **off** — they block `git push` to `main` (checks run after GitHub has the commit). Stay on `main` for daily work. Use a branch + PR when you want to see a gate fail (KAN-55).
