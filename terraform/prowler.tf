# KAN-56: read-only GitHub OIDC role for Prowler. Not the deploy role.
# Same trust as cloudsec-lab-github (this repo, main only). Apply on the Mac.

resource "aws_iam_role" "github_prowler" {
  name               = "${var.name}-github-prowler"
  assume_role_policy = data.aws_iam_policy_document.github_assume.json
}

resource "aws_iam_role_policy_attachment" "github_prowler_securityaudit" {
  role       = aws_iam_role.github_prowler.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "github_prowler_viewonly" {
  role       = aws_iam_role.github_prowler.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
