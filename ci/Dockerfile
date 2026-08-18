# Golden CI image for GitHub Actions (linux/amd64).
# Not the Fargate app image (that's root Dockerfile, linux/arm64).
# Jobs call terraform / trivy / gitleaks / prowler on PATH. No docker-in-docker.

FROM python:3.12-slim-bookworm

ARG TERRAFORM_VERSION=1.9.8
ARG TERRAFORM_SHA256=186e0145f5e5f2eb97cbd785bc78f21bae4ef15119349f6ad4fa535b83b10df8
ARG TRIVY_VERSION=0.74.0
ARG TRIVY_SHA256=2ae6fe3ee734b7fdf11335663e18c75ea12dccc76062f09f164a3b0f8be4371a
ARG GITLEAKS_VERSION=8.28.0
ARG GITLEAKS_SHA256=a65b5253807a68ac0cafa4414031fd740aeb55f54fb7e55f386acb52e6a840eb
ARG PROWLER_VERSION=5.39.1

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/terraform.zip \
      "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && echo "${TERRAFORM_SHA256}  /tmp/terraform.zip" | sha256sum -c - \
    && unzip -o /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip \
    && terraform version

RUN curl -fsSL -o /tmp/trivy.tar.gz \
      "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" \
    && echo "${TRIVY_SHA256}  /tmp/trivy.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/trivy.tar.gz -C /tmp trivy \
    && mv /tmp/trivy /usr/local/bin/trivy \
    && rm /tmp/trivy.tar.gz \
    && trivy --version

RUN curl -fsSL -o /tmp/gitleaks.tar.gz \
      "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" \
    && echo "${GITLEAKS_SHA256}  /tmp/gitleaks.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/gitleaks.tar.gz -C /tmp gitleaks \
    && mv /tmp/gitleaks /usr/local/bin/gitleaks \
    && rm /tmp/gitleaks.tar.gz \
    && gitleaks version

# 5.39.0 is the Docker Hub tag we used; PyPI skipped it. 5.39.1 is the pin on PyPI.
RUN pip install --no-cache-dir "prowler==${PROWLER_VERSION}" \
    && prowler -v

# Actions `run:` steps. Do not ENTRYPOINT prowler (that would steal every command).
WORKDIR /workspace
CMD ["bash"]
