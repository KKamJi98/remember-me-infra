resource "aws_chatbot_slack_channel_configuration" "this" {
  configuration_name    = var.configuration_name
  iam_role_arn          = var.iam_role_arn
  slack_channel_id      = var.slack_channel_id
  slack_team_id         = var.slack_team_id
  sns_topic_arns        = [var.sns_topic_arns]
  guardrail_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}