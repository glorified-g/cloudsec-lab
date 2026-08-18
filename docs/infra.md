# Infra pipeline (fmt / validate)

GitHub Actions on `terraform/**` (or **Run workflow**): `terraform fmt -check`, `init -backend=false`, `validate`.

This is **not** `plan` or `apply`. Those stay on the Mac with `ken-lab` ([scale.md](scale.md)). CI has no AWS credentials in this workflow. Trivy is a later card.

If `fmt` fails: on the Mac, `cd terraform && terraform fmt -recursive`, commit, push.

App changes do not start this workflow. Terraform changes do not start **deploy**.
