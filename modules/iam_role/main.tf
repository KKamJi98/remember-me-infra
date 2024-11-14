resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = file(var.policy_file)
}