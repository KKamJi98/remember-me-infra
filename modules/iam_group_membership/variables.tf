variable "group_name" {
  description = "The name of the IAM group."
  type        = string
}

variable "membership_name" {
  description = "The name of the IAM group membership."
  type        = string
}

variable "user_names" {
  description = "A list of IAM user names."
  type        = list(string)
}

variable "user_path" {
  description = "The path for IAM users."
  type        = string
  default     = "/"
}

variable "pgp_key" {
  type        = string
  default     = "keybase:username"
  description = "Provide a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Required to encrypt password."
}

variable "policy_file" {
  type        = string
  description = "Path to JSON policy file"
}