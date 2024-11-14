provider "aws" {
  region = var.region
}

###############################################################
## iam_group_membership
###############################################################

module "dev_group" {
  source          = "./modules/iam_group_membership"
  group_name      = "dev-group"
  membership_name = "dev-group-membership"
  user_names      = ["ycs"]
  user_path       = "/dev/"
  pgp_key         = var.pgp_key
  policy_file     = "${path.module}/templates/dev-policy.json"
}

module "infra_group" {
  source          = "./modules/iam_group_membership"
  group_name      = "infra-group"
  membership_name = "infra-group-membership"
  user_names      = ["ktj", "cbh"]
  user_path       = "/infra/"
  pgp_key         = var.pgp_key
  policy_file     = "${path.module}/templates/infra-policy.json"
}

###############################################################
## iam_policy
###############################################################

module "lambda_iam_policy" {
  source      = "./modules/iam_policy"
  name        = "lambda-policy"
  policy_file = "${path.module}/templates/lambda-policy.json"
}

###############################################################
## iam_role
###############################################################

module "lambda_iam_role" {
  source      = "./modules/iam_role"
  name        = "lambda-role"
  policy_file = "${path.module}/templates/lambda-assume-role-policy.json"
}