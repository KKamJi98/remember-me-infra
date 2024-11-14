variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

###############################################################
## iam_group_membership
###############################################################

variable "pgp_key" {
  description = "Provide a base-64 encoded PGP public key for dev, or a keybase username in the form `keybase:username`. Required to encrypt password."
  type        = string
}