variable "name" {
  type        = string
  description = "Name of the IAM Role"
}

variable "policy_file" {
  type        = string
  description = "Path to JSON file for the IAM Policy"
}