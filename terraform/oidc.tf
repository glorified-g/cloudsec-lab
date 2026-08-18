# GitHub Actions → AWS via OIDC. No access keys in GitHub Secrets.
# Trust is limited to this repo's main branch. Apply stays local (KAN-51);
# the role is sized for the KAN-62 deploy (ECR push + ECS update).

data "aws_iam_policy_document" "github_assume" {
  statement {
    sid = "GitHubActionsOidc"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:TagSession",
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # Leaf certs rotate; include the historical GitHub/DigiCert print plus current ISRG Root YR.
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "ab9d0263244dd0326eb67015705a667e79cfe998",
  ]
}

resource "aws_iam_role" "github" {
  name               = "${var.name}-github"
  assume_role_policy = data.aws_iam_policy_document.github_assume.json
}

data "aws_iam_policy_document" "github_deploy" {
  statement {
    sid       = "EcrAuth"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "EcrPush"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.app.arn]
  }

  statement {
    sid = "EcsDeploy"
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
    ]
    resources = ["*"]
  }

  statement {
    sid = "PassTaskRoles"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      aws_iam_role.execution.arn,
      aws_iam_role.task.arn,
    ]
  }
}

resource "aws_iam_role_policy" "github_deploy" {
  name   = "${var.name}-github-deploy"
  role   = aws_iam_role.github.id
  policy = data.aws_iam_policy_document.github_deploy.json
}
