resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "cloudfront_origin_access_identity comment"
}

resource "aws_cloudfront_distribution" "example" {
  origin {
    domain_name = var.s3_domain_name
    origin_id   = var.s3_id


    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }

    origin_shield {
      enabled              = true
      origin_shield_region = "ap-northeast-2"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "test comment"
  default_root_object = "index.html"

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
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.acm_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }
}