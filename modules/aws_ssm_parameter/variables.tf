variable "name" {
  type        = string
  description = "Name of the parameter"
}

variable "type" {
  type        = string
  description = "Type of the parameter. Valid types are String, StringList, SecureString"
}

variable "value" {
  type        = string
  description = "Value of the parameter"
}