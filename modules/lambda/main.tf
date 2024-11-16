resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  filename      = var.filename
  layers        = var.layer_arns
  handler       = var.handler
  runtime       = var.runtime
}