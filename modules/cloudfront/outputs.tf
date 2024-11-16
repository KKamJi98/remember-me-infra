output "cdn_arn" {
  description = "The ARN of the cloudfront."
  value       = aws_cloudfront_distribution.s3_distribution.arn
}

output "domain_name" {
  description = "The domain name for the cloudfront."
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "distribution_id" {
  description = "The ID of the cloudfront."
  value       = aws_cloudfront_distribution.s3_distribution.id
}