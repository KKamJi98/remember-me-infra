output "waf_acl_arn" {
  description = "The ARN of the WAF ACL."
  value       = aws_wafv2_web_acl.example.arn
}

output "waf_alarm_sns_topic_arn" {
  value       = aws_sns_topic.waf_alarm_topic.arn
  description = "ARN identification of the waf alarms SNS topic."
}