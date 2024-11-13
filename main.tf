provider "aws" {
  region = var.region
}

###############################################################
##                      Parameter Store                      ##
###############################################################
data "aws_ssm_parameter" "pgp_key" {
  name = "/terraform/keybase/pgp_key"
}

########################IAM User Group#########################
# IAM User, User Group 생성
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
# module "dev_group" {
#   source          = "./modules/iam_group_membership"
#   group_name      = "dev-group"
#   membership_name = "dev-group-membership"
#   user_names      = ["ycs"]
#   user_path       = "/dev/"
#   pgp_key         = data.aws_ssm_parameter.pgp_key.value
#   policy_file     = "${path.module}/templates/dev-policy.json"
# }

# module "infra_group" {
#   source          = "./modules/iam_group_membership"
#   group_name      = "infra-group"
#   membership_name = "infra-group-membership"
#   user_names      = ["ktj", "cbh"]
#   user_path       = "/infra/"
#   pgp_key         = data.aws_ssm_parameter.pgp_key.value
#   policy_file     = "${path.module}/templates/infra-policy.json"
# }