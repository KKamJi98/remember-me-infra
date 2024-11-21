variable "configuration_name" {
  description = "The name of the configuration."
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role that defines the permissions for AWS Chatbot."
  type        = string
}

variable "slack_channel_id" {
  description = "The ID of the Slack channel."
  type        = string
}

variable "slack_team_id" {
  description = "The ID of the Slack workspace authorized with AWS Chatbot"
  type        = string
}

variable "sns_topic_arns" {
  description = "The ARNs of the SNS topics that deliver notifications to AWS Chatbot."
  type        = string
}