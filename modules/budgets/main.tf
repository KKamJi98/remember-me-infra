resource "aws_sns_topic" "account_billing_alarm_topic" {
  name = "account-billing-alarm-topic"
}

resource "aws_sns_topic_policy" "account_billing_alarm_policy" {
  arn    = aws_sns_topic.account_billing_alarm_topic.arn
  policy = local.policy_content
}

locals {
  policy_content  = file(var.policy_file)
  replaced_policy = replace(local.policy_content, "TOPIC_ARN", aws_sns_topic.account_billing_alarm_topic.arn)
}

resource "aws_budgets_budget" "budget_account" {
  name              = "${var.account_name} Account Monthly Budget"
  budget_type       = "COST"
  limit_amount      = var.account_budget_limit
  limit_unit        = var.budget_limit_unit
  time_unit         = var.budget_time_unit
  time_period_start = "2024-11-12_00:00"

  dynamic "notification" {
    for_each = var.notifications

    content {
      comparison_operator = notification.value.comparison_operator
      threshold           = notification.value.threshold
      threshold_type      = notification.value.threshold_type
      notification_type   = notification.value.notification_type
      subscriber_sns_topic_arns = [
        aws_sns_topic.account_billing_alarm_topic.arn
      ]
    }
  }

  depends_on = [
    aws_sns_topic.account_billing_alarm_topic
  ]
}

resource "aws_budgets_budget" "budget_resources" {
  for_each = var.services

  name              = "${var.account_name} ${each.key} Monthly Budget"
  budget_type       = "COST"
  limit_amount      = each.value.budget_limit
  limit_unit        = var.budget_limit_unit
  time_unit         = var.budget_time_unit
  time_period_start = "2024-11-12_00:00"

  cost_filter {
    name = var.cost_filter_name
    values = [
      lookup(local.aws_services, each.key)
    ]
  }

  dynamic "notification" {
    for_each = var.notifications

    content {
      comparison_operator = notification.value.comparison_operator
      threshold           = notification.value.threshold
      threshold_type      = notification.value.threshold_type
      notification_type   = notification.value.notification_type
      subscriber_sns_topic_arns = [
        aws_sns_topic.account_billing_alarm_topic.arn
      ]
    }
  }

  depends_on = [
    aws_sns_topic.account_billing_alarm_topic
  ]
}