variable "s3_domain_name" {
  type        = string
  description = "Domain name of the S3"
}

variable "s3_id" {
  type        = string
  description = "Id of the S3"
}

variable "acm_arn" {
  type        = string
  description = "The ARN of the ACM"
}

variable "cdn_alias" {
  type        = string
  description = "Alias of the Cloudfront"
}

variable "waf_acl_arn" {
  type        = string
  description = "The ARN of the WAF ACL"
}