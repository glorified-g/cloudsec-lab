# KAN-55 planted finding. Do not merge. Do not terraform apply.
#
# Action = "*" is AVD-AWS-0057 — deprecated; Trivy 0.74 does not fail HIGH on it.
# Action = "s3:*" is AVD-AWS-0345 — still HIGH.

data "aws_iam_policy_document" "planted_admin_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "planted_admin" {
  name               = "${var.name}-planted-admin"
  assume_role_policy = data.aws_iam_policy_document.planted_admin_assume.json
}

resource "aws_iam_role_policy" "planted_s3_star" {
  name = "${var.name}-planted-s3-star"
  role = aws_iam_role.planted_admin.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:*"
      Resource = "*"
    }]
  })
}
