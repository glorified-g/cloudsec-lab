# Infra pipeline (fmt / validate / Trivy IaC)

GitHub Actions on `terraform/**` (or **Run workflow**): `terraform fmt -check`, `init -backend=false`, `validate`, then Trivy config.

Apply stays on the Mac ([scale.md](scale.md)). Three IaC findings are ignored on purpose ([security.md](security.md), `.trivyignore`).
