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
}