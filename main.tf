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

###############################################################
## iam_role_policy_attachment
###############################################################

module "lambda_role_policy_attachment" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.lambda_iam_role.name
  policy_arn = module.lambda_iam_policy.arn
}

###############################################################
## S3
###############################################################

module "s3" {
  source      = "./modules/s3"
  name        = "english-voca-deploy"
  policy_file = "${path.module}/templates/s3-policy.json"
}

###############################################################
## lambda_function
###############################################################

module "lambda" {
  source        = "./modules/lambda"
  role_arn      = module.lambda_iam_role.arn
  filename      = "${path.module}/templates/lambda/lambda_code.zip"
  function_name = "voca_app_lambda"
  runtime       = "nodejs20.x"
}