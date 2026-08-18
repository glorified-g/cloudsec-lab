# Deploy from git push

Push to `app/`, `Dockerfile`, or this workflow → **test → build linux/arm64 → ECR `:gha` → ECS force-new-deployment**.

This is GitHub Actions (OIDC). It does **not** run Terraform and does **not** change `desired_count`. Start/stop stays [scale.md](scale.md).

The task definition already uses the mutable tag `:gha`. CI overwrites that tag and tells ECS to launch a new task. CI does not register a new task-definition revision (Terraform still owns that).

## If Fargate is at 0

The workflow still pushes the image and calls `update-service --force-new-deployment`. Nothing runs until you scale up. Then the new `:gha` digest is what starts.

## See a version bump (service already at 1)

1. Scale up ([scale.md](scale.md)). Note the URL and **Version** on the page.
2. Change `VERSION` in `app/app.py`.
3. Commit and push `main` (only `app/` needs to be in the commit).
4. Wait for Actions → **deploy** (test, then the ARM build — several minutes).
5. The running task is replaced → **new public IP**. From `terraform/`:

```bash
export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"
export AWS_PROFILE=ken-lab
../scripts/ecs-url.sh
```

6. Confirm the new version. Then scale down.

README-only commits do not start this workflow.
