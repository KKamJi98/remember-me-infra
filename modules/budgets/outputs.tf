output "budget_alarms_sns_topic_arn" {
  value       = aws_sns_topic.account_billing_alarm_topic.arn
  description = "ARN identification of the budget alarms SNS topic."
}