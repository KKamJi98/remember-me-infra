variable "name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "policy_file" {
  type        = string
  description = "Path to JSON file for the S3 Policy"
}