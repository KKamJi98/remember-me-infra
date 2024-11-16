resource "aws_apigatewayv2_api" "this" {
  name = var.name
  # HTTP, WEBSOCKET
  protocol_type = var.protocol_type
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.method_lambda_map

  api_id = aws_apigatewayv2_api.this.id
  #AWS_PROXY, HTTP_PROXY
  integration_type       = var.integration_type
  integration_uri        = each.value.invoke_arn
  payload_format_version = var.payload_format_version
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.method_lambda_map

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

