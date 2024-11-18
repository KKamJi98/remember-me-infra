resource "aws_wafv2_ip_set" "white_list_ip_list" {
  name               = "test-name"
  description        = "white ip set"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["112.214.32.67"] # 조건에서 제외시킬 ip 추가
}

resource "aws_wafv2_web_acl" "example" {
  name  = "rate-based-example"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL", "KR"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "overrated-metrics"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "metrics"
    sampled_requests_enabled   = false
  }
}
