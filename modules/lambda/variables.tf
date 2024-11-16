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

variable "api_gateway_source_arn" {
  type        = string
  description = "ARN of the API Gateway to be used by the lambda function"
}