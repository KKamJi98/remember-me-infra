variable "function_name" {
  type        = string
  description = "Name of the lambda function"
}

variable "role_arn" {
  type        = string
  description = "ARN of the role to be used by the lambda function"
}

variable "filename" {
  type        = string
  description = "Path to the lambda function's source code"
}

variable "layer_arns" {
  type        = list(string)
  description = "ARNs of the layers to be used by the lambda function"
  default     = []
}

variable "runtime" {
  type        = string
  description = "Runtime of the lambda function"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the lambda function"
  default     = {}
}

variable "handler" {
  type        = string
  description = "Handler of the lambda function"
  default     = "index.handler"
}

variable "lambda_permission_statement_id" {
  type        = string
  description = "Statement ID of the lambda permission"
}

variable "lambda_permission_action" {
  type        = string
  description = "Action of the lambda permission"
  default     = "lambda:InvokeFunction"
}

variable "lambda_permission_principal" {
  type        = string
  description = "Principal of the lambda permission"
  default     = "apigateway.amazonaws.com"
}

variable "lambda_permission_source_arn" {
  type        = string
  description = "Source ARN of the lambda permission"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain the lambda function's logs 0, 1, 3, 5, 7, 14, 30 ..."
  default     = 14
}

variable "log_subscription_filter_pattern" {
  type        = string
  description = "Filter pattern for the lambda function's log group"
  default     = ""
}

variable "log_subscription_filter_destination_arn" {
  type        = string
  description = "Destination ARN for the filtered logs"
  default     = ""
}

variable "create_log_subscription_filter" {
  type        = bool
  description = "Whether to create a subscription filter for the lambda function's log group"
  default     = false
}