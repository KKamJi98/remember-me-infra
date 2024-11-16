output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.deploy_bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.deploy_bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint for the S3 bucket."
  value       = aws_s3_bucket_website_configuration.website-config.website_endpoint
}

output "id" {
  description = "The Id of the S3 bucket."
  value       = aws_s3_bucket.deploy_bucket.id
}