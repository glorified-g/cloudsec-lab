#!/usr/bin/env bash
# CIS AWS 2.0 in us-east-1. Report only. Needs Docker + profile ken-lab.
# Mac Mini is arm64; the Prowler image is amd64 (same QEMU lesson as Fargate CI).
set -euo pipefail
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE="${AWS_PROFILE:-ken-lab}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/prowler-output"
IMAGE="prowlercloud/prowler:5.39.0"
mkdir -p "$OUT"

aws sts get-caller-identity

docker run --rm \
  --platform linux/amd64 \
  -e AWS_PROFILE \
  -e AWS_DEFAULT_REGION=us-east-1 \
  -v "$HOME/.aws:/home/prowler/.aws:ro" \
  -v "$OUT:/home/prowler/output" \
  "$IMAGE" \
  aws --region us-east-1 --compliance cis_2.0_aws \
    --output-formats csv json-ocsf html --ignore-exit-code-3

echo "Reports in $OUT"
