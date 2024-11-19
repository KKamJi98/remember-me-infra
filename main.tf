provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
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

module "lambda_role_policy_attachment_inline" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.lambda_iam_role.name
  policy_arn = module.lambda_iam_policy.arn
}

module "lambda_role_policy_attachment_log" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

###############################################################
## S3
###############################################################

module "s3" {
  source      = "./modules/s3"
  name        = "english-voca-deploy"
  policy_file = "${path.module}/templates/s3-policy.json"
}

module "parameter_store_s3_bucket_name" {
  source = "./modules/aws_ssm_parameter"
  name   = "/remember-me/s3-bucket-name"
  type   = "String"
  value  = module.s3.bucket_name
}

###############################################################
## cloudfront
###############################################################

module "cloudfront" {
  source         = "./modules/cloudfront"
  s3_domain_name = module.s3.domain_name
  s3_id          = module.s3.id
  acm_arn        = module.route53.acm_arn
}

module "parameter_store_cloudfront_distribution_id" {
  source = "./modules/aws_ssm_parameter"
  name   = "/remember-me/cloudfront-distribution-id"
  type   = "String"
  value  = module.cloudfront.distribution_id
}

###############################################################
## route53
###############################################################

module "route53" {
  source             = "./modules/route53"
  domain_name        = "kkamji.net"
  cdn_domain_name    = module.cloudfront.domain_name
  cdn_hosted_zone_id = module.cloudfront.hosted_zone_id

  providers = {
    aws = aws.us_east_1
  }
}

###############################################################
## WAF
###############################################################

module "WAF" {
  source = "./modules/waf"

  providers = {
    aws = aws.us_east_1
  }
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
    "GET /user" = {
      lambda_invoke_arn = module.lambda_get_user.invoke_arn
      lambda_name       = module.lambda_get_user.name
    },
    "GET /lists" = {
      lambda_invoke_arn = module.lambda_get_lists.invoke_arn
      lambda_name       = module.lambda_get_lists.name
    },
    "POST /list" = {
      lambda_invoke_arn = module.lambda_post_list.invoke_arn
      lambda_name       = module.lambda_post_list.name
    },
    "POST /words" = {
      lambda_invoke_arn = module.lambda_post_words.invoke_arn
      lambda_name       = module.lambda_post_words.name
    },
    "POST /word" = {
      lambda_invoke_arn = module.lambda_post_word.invoke_arn
      lambda_name       = module.lambda_post_word.name
    },
    "GET /incorrectLists" = {
      lambda_invoke_arn = module.lambda_get_incorrect_lists.invoke_arn
      lambda_name       = module.lambda_get_incorrect_lists.name
    },
    "POST /incorrectList" = {
      lambda_invoke_arn = module.lambda_post_incorrect_list.invoke_arn
      lambda_name       = module.lambda_post_incorrect_list.name
    },
    "POST /incorrectWords" = {
      lambda_invoke_arn = module.lambda_post_incorrect_words.invoke_arn
      lambda_name       = module.lambda_post_incorrect_words.name
    },
    "POST /incorrectWord" = {
      lambda_invoke_arn = module.lambda_post_incorrect_word.invoke_arn
      lambda_name       = module.lambda_post_incorrect_word.name
    }
  }
}

module "parameter_store_api_gateway_endpoint" {
  source = "./modules/aws_ssm_parameter"
  name   = "/remember-me/api_gateway_endpoint_invoke_url"
  type   = "String"
  value  = module.api_gateway.invoke_url
}

###############################################################
## lambda_functions
###############################################################

module "lambda_get_user" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "getUser"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_get_lists" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "getLists"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_list" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postList"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_words" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postWords"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_word" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postWord"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_get_incorrect_lists" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "getIncorrectLists"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_incorrect_list" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postIncorrectList"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_incorrect_words" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postIncorrectWords"
  runtime                        = "nodejs20.x"
  lambda_permission_statement_id = "AllowAPIGatewayInvoke"
  api_gateway_source_arn         = "${module.api_gateway.execution_arn}/*/*"
}

module "lambda_post_incorrect_word" {
  source                         = "./modules/lambda"
  role_arn                       = module.lambda_iam_role.arn
  filename                       = "${path.module}/templates/lambda/lambda_code.zip"
  function_name                  = "postIncorrectWord"
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