output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.example.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.example.arn
}

output "website_endpoint" {
  description = "The website endpoint for the S3 bucket."
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
}

output "id" {
  description = "The Id of the S3 bucket."
  value       = aws_s3_bucket.example.id
}

output "domain_name" {
  description = "The Domain name of the S3 bucket."
  value       = aws_s3_bucket.example.bucket_domain_name
}