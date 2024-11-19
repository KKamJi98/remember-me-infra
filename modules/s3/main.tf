resource "aws_s3_bucket" "example" {
  bucket        = var.name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

locals {
  policy_content        = file(var.policy_file)
  replaced_policy       = replace(local.policy_content, "BUCKET_ARN", aws_s3_bucket.example.arn)
  replaced_policy_final = replace(local.policy_content, "CDN_ARN", var.cdn_arn)
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = local.replaced_policy_final

  depends_on = [aws_s3_bucket_acl.example]
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id
  index_document {
    suffix = "index.html"
  }
}