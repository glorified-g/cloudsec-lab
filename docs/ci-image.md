# Golden CI image (GHCR)

Pinned CLIs for GitHub Actions: terraform **1.9.8**, trivy **0.74.0**, gitleaks **v8.28.0**, prowler **5.39.1**.

`ghcr.io/glorified-g/cloudsec-lab-ci` — **linux/amd64** only. Not the Fargate app image (`Dockerfile`, linux/arm64, ECR).

Jobs will call the binaries (no `docker run` of Trivy/Gitleaks/Prowler, no docker-in-docker). Public package + `ubuntu-latest` stays **$0**. Do not put this image in ECR or on a larger runner.

## Version

`ci/VERSION` is the GHCR tag (`1.0.0`). Bump it when you change pins in `ci/Dockerfile`. Weekly Monday rebuild overwrites the same tag (base-image patches).

## Publish

Path filter: `ci/**` and this workflow. README-only commits do not build it. Or **Actions → ci-image → Run workflow**.

First package from a public repo is often **private**. After the first green run:

GitHub → Packages → `cloudsec-lab-ci` → Package settings → Change visibility → **Public**.

Until that click, only this repo’s `GITHUB_TOKEN` can pull it.

## After the image exists

Point `infra.yml`, `security.yml`, and `prowler.yml` at `ghcr.io/glorified-g/cloudsec-lab-ci:1.0.0` (`container:` on the job). Do not switch those workflows in the same commit as the first publish — they would race the push.

`deploy.yml` still needs Docker (Buildx → ECR). Leave its Trivy image scan on `docker run` / docker.sock.

Local Prowler on the Mac stays `scripts/prowler.sh` (official amd64 image via QEMU).
