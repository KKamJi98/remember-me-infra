variable "role_name" {
  type        = string
  description = "Name of the IAM Role"
}

variable "policy_arn" {
  type        = string
  description = "ARN of the IAM Policy to attach"
}