variable "account_name" {
  description = "Specifies the name of the AWS account"
  type        = string
}

variable "account_budget_limit" {
  description = "Set the budget limit for the AWS account."
  type        = string
}

variable "budget_limit_unit" {
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold."
  type        = string
  default     = "USD"
}

variable "budget_time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend. Valid values: `MONTHLY`, `QUARTERLY`, `ANNUALLY`."
  type        = string
  default     = "MONTHLY"
}

variable "cost_filter_name" {
  description = "The name of cost filter"
  type        = string
}

variable "services" {
  description = "Define the list of services and their limit of budget."

  type = map(object({
    budget_limit = string
  }))
}

variable "notifications" {
  description = "Can be used multiple times to configure budget notification thresholds."
  type = map(object({
    comparison_operator = string
    threshold           = number
    threshold_type      = string
    notification_type   = string
  }))
}

variable "policy_file" {
  type        = string
  description = "Path to JSON file for the SNS-topic Policy"
}