## aws_lambda_layer_version
variable "filename" {
  type        = string
  description = "Path to zip file"
}

variable "layer_name" {
  type        = string
  description = "Name of the layer"
}

variable "compatible_runtimes" {
  type = list(string)
}