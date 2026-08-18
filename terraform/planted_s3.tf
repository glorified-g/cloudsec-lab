# KAN-55 planted finding. Do not merge. Do not terraform apply.
resource "aws_s3_bucket" "planted_public" {
  bucket = "${var.name}-planted-public"
}

resource "aws_s3_bucket_public_access_block" "planted_public" {
  bucket = aws_s3_bucket.planted_public.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
