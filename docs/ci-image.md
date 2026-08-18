# Golden CI image (GHCR)

Pinned CLIs for GitHub Actions: terraform **1.9.8**, trivy **0.74.0**, gitleaks **v8.28.0**, prowler **5.39.1**.

Package: [cloudsec-lab-ci](https://github.com/glorified-g/cloudsec-lab/pkgs/container/cloudsec-lab-ci)  
Pull: `ghcr.io/glorified-g/cloudsec-lab-ci:1.0.0`

**linux/amd64** only. Not the Fargate app image (`Dockerfile`, linux/arm64, ECR). Not in AWS.

`infra.yml`, `security.yml`, and `prowler.yml` run inside this image and call the binaries. No docker-in-docker. `deploy.yml` still uses Docker (Buildx → ECR) and `aquasec/trivy` for the ARM64 image scan.

Public package + `ubuntu-latest` stays **$0**.

## Version

`ci/VERSION` is the GHCR tag. Bump it when you change pins in `ci/Dockerfile`, rebuild, then update the `:1.0.0` pin in the three workflows. Weekly Monday rebuild overwrites the same tag (base-image patches).

## Publish

Path filter: `ci/**` and `.github/workflows/ci-image.yml`. README-only commits do not build it. Or **Actions → ci-image → Run workflow**.

Local Prowler on the Mac stays `scripts/prowler.sh` (official amd64 image via QEMU).
