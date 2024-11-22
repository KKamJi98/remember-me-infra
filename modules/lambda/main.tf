resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  filename      = var.filename
  layers        = var.layer_arns
  handler       = "${var.function_name}.handler"
  runtime       = var.runtime

  lifecycle {
    ignore_changes = [layers]
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = var.lambda_permission_statement_id
  action        = var.lambda_permission_action
  function_name = aws_lambda_function.this.function_name
  principal     = var.lambda_permission_principal
  source_arn    = var.lambda_permission_source_arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  name            = "${var.function_name}-subscription"
  log_group_name  = aws_cloudwatch_log_group.this.name
  filter_pattern  = var.log_subscription_filter_pattern
  destination_arn = var.log_subscription_filter_destination_arn
}