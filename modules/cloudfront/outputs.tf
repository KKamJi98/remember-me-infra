output "cdn_arn" {
  description = "The ARN of the cloudfront."
  value       = aws_cloudfront_distribution.example.arn
}

output "domain_name" {
  description = "The domain name for the cloudfront."
  value       = aws_cloudfront_distribution.example.domain_name
}

output "hosted_zone_id" {
  description = "The hosted zone id for the cloudfront."
  value       = aws_cloudfront_distribution.example.hosted_zone_id
}