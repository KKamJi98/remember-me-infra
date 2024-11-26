terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.75"
    }
  }
}

resource "aws_sns_topic" "waf_alarm_topic" {
  name = "waf-alarm-topic"
}

resource "aws_sns_topic_policy" "waf_alarm_policy" {
  arn    = aws_sns_topic.waf_alarm_topic.arn
  policy = local.policy_content
}

locals {
  policy_content  = file(var.policy_file)
  replaced_policy = replace(local.policy_content, "TOPIC_ARN", aws_sns_topic.waf_alarm_topic.arn)
}

resource "aws_cloudwatch_metric_alarm" "waf_alarm" {
  alarm_name          = "WAF-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests" # WAF의 Blocked Requests 메트릭 사용
  namespace           = "AWS/WAFV2/Rule, WebACL"
  period              = 300 # 5분 단위 평가
  statistic           = "Sum"
  threshold           = 2 # 블록된 요청이 2개 이상이면 알람
  alarm_description   = "Triggered when WAF detects more than 2 blocked requests in 5 minutes."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.waf_alarm_topic.arn]

  dimensions = {
    WebACL = aws_wafv2_web_acl.example.name
    Rule   = "BlockedRequests"
  }
}

resource "aws_wafv2_ip_set" "white_list_ip_list" {
  name               = "test-name"
  description        = "white ip set"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["112.214.32.67/32", "58.29.228.105/32"] # 조건에서 제외시킬 ip 추가
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
        limit              = 500
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
      metric_name                = "BlockedRequests"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "metrics"
    sampled_requests_enabled   = true
  }
}