#aws_apigatewayv2_api
variable "name" {
  type        = string
  description = "The name of the API Gateway"
}

variable "protocol_type" {
  type        = string
  description = "The API protocol, for example HTTP or WEBSOCKETS"
}

variable "allow_headers" {
  type        = list(string)
  description = "The allow headers"
  default     = ["*"]
}

variable "allow_methods" {
  type        = list(string)
  description = "The allow methods"
  default     = ["*"]
}

variable "allow_origins" {
  type        = list(string)
  description = "The allow origins"
  default     = ["*"]
}

variable "expose_headers" {
  type        = list(string)
  description = "The expose headers"
  default     = []
}

variable "max_age" {
  type        = number
  description = "The maximum age in seconds"
  default     = 3600
}

variable "stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
}

variable "method_lambda_map" {
  type = map(object({
    lambda_invoke_arn = string
    lambda_name       = string
  }))
  description = "The map of method and lambda"
}

variable "integration_type" {
  type        = string
  description = "The integration type, for example AWS_PROXY or HTTP_PROXY"
  default     = "AWS_PROXY"
}

variable "payload_format_version" {
  type        = string
  description = "The payload format version"
}