resource "aws_apigatewayv2_api" "this" {
  name = var.name
  # HTTP, WEBSOCKET
  protocol_type = var.protocol_type

  cors_configuration {
    allow_headers  = var.allow_headers
    allow_methods  = var.allow_methods
    allow_origins  = var.allow_origins
    expose_headers = var.expose_headers
    max_age        = var.max_age
  }
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
  integration_uri        = each.value.lambda_invoke_arn
  payload_format_version = var.payload_format_version
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.method_lambda_map

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

