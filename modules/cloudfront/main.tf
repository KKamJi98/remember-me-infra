terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.75"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "s3-cloudfront-oac"
  description                       = "Grant cloudfront access to s3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "example" {
  origin {
    domain_name              = var.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.example.id
    origin_id                = var.s3_id

    origin_shield {
      enabled              = true
      origin_shield_region = "ap-northeast-2"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "test comment"
  default_root_object = "index.html"
  web_acl_id          = var.waf_acl_arn

  aliases = [var.cdn_alias]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "KR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }
}