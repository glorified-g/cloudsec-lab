# KAN-55 planted finding. Do not merge. Do not terraform apply.
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

resource "aws_iam_role_policy" "planted_admin" {
  name = "${var.name}-planted-admin"
  role = aws_iam_role.planted_admin.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}
