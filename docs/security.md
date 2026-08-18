# Security scans (Trivy + Gitleaks)

Same tools you ran on the Mac, in GitHub Actions.

| Scan | Where | Fails the job? |
|------|--------|----------------|
| Gitleaks | `security.yml` | Yes, if a secret is in git |
| Trivy filesystem | `security.yml` | Yes, HIGH/CRITICAL in app deps (`requirements.txt` was 0) |
| Trivy IaC | `infra.yml` | Yes, HIGH/CRITICAL **except** IDs in `.trivyignore` |
| Trivy image (libraries) | `deploy.yml` after push | Yes, HIGH/CRITICAL in Flask/pip packages |
| Trivy image (OS) | `deploy.yml` after push | No — Debian in `python:3.12-slim` currently has ~26 HIGH/CRITICAL; report only |

`.trivyignore` skips three Terraform findings we are keeping on purpose:

- **AVD-AWS-0031** — ECR tag mutability. `:gha` is overwritten by CI.
- **AVD-AWS-0104** — SG egress `0.0.0.0/0`. No NAT; the task has to reach ECR/logs.
- **AVD-AWS-0164** — public subnet `map_public_ip_on_launch`. No ALB.

`app/.venv` is in `.dockerignore` so the Mac venv is not copied into the image.

Branch protection (require these checks on PRs) is a GitHub UI step after the workflows are green. Direct pushes to `main` still run the jobs; they are not blocked unless you turn on “require pull request.”
