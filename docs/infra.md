# Infra pipeline (fmt / validate / Trivy IaC)

GitHub Actions on `terraform/**` (or **Run workflow**): `terraform fmt -check`, `init -backend=false`, `validate`, then Trivy config. Job runs in `ghcr.io/glorified-g/cloudsec-lab-ci:1.0.0` ([ci-image.md](ci-image.md)).

Apply stays on the Mac ([scale.md](scale.md)). Three IaC findings are ignored on purpose ([security.md](security.md), `.trivyignore`).
