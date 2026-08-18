# Prowler (CSPM)

Trivy scans **git** (Terraform / image / deps). Prowler scans **live AWS** via APIs. Different question: “what is actually in the account?”

Pinned image: `prowlercloud/prowler:5.39.0`. First slice: **CIS AWS 2.0**, region **us-east-1**. Report only — this lab will fail many CIS checks (no CloudTrail, public SG :8080, no password policy, …). That is the point.

Reports stay out of git (`prowler-output/`). Actions uploads them as an artifact.

## Local (Mac)

```bash
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE=ken-lab
cd /Users/glo/repos/cloudsec-lab
./scripts/prowler.sh
```

Takes several minutes. Open the `.html` file under `prowler-output/` (`open prowler-output/*.html`).

Prowler 5.39 dropped `-M json`. Use `csv`, `json-ocsf`, or `html`.

NIST later: same image, `--compliance nist_800_53_revision_5_aws` (longer).

## GitHub Actions

Role **`cloudsec-lab-github-prowler`**: OIDC, this repo’s `main` only, `SecurityAudit` + `ViewOnlyAccess`. Not the deploy role.

1. Apply on the Mac (pass `image_tag=gha` so the task def does not revert):

```bash
cd /Users/glo/repos/cloudsec-lab/terraform
terraform apply -var='image_tag=gha'
```

Plan should add the prowler role only.

2. Push the workflow, then **Actions → prowler → Run workflow**.

Does not run on `git push`. Does not change `desired_count`.
