variable "domain_name" {
  type        = string
  description = "The domain name for the A record (e.g., www.example.com)."
}

variable "cdn_domain_name" {
  type        = string
  description = "The domain name for the cloudfront."
}

variable "cdn_hosted_zone_id" {
  type        = string
  description = "The hosted zone id for the cloudfront."
}