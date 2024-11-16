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
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "voca_app_lambda"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

###############################################################
## lambda_layer
###############################################################

module "lambda_layer" {
  source     = "./modules/lambda_layer"
  layer_name = "voca_app_lambda_layer"
  filename   = "${path.module}/templates/lambda/lambda_layer.zip"

  compatible_runtimes = ["nodejs20.x"]
}

###############################################################
## parameter_store
###############################################################

module "aws_ssm_parameter" {
  source = "./modules/aws_ssm_parameter"
  name   = "parameter"
  type   = "String"
  value  = "value"
}

###############################################################
## api_gateway
###############################################################

module "api_gateway" {
  source = "./modules/api_gateway"

  name                   = "voca-app-api-gateway"
  protocol_type          = "HTTP"
  stage_name             = "prod"
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"

  method_lambda_map = {
    "GET /test" = {
      lambda_invoke_arn = module.lambda.invoke_arn
      lambda_name       = module.lambda.name
    }
    # "POST /..." = {

    # }...
  }
}

###############################################################
## cloudfront
###############################################################

module "cloudfront" {
  source         = "./modules/cloudfront"
  s3_domain_name = module.s3.website_endpoint
  s3_id          = module.s3.id
}