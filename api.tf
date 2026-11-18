resource "aws_apigatewayv2_api" "tickets" {
  name          = "support-ticket-triage"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "triage" {
  api_id                 = aws_apigatewayv2_api.tickets.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.triage.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_ticket" {
  api_id    = aws_apigatewayv2_api.tickets.id
  route_key = "POST /tickets"
  target    = "integrations/${aws_apigatewayv2_integration.triage.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.tickets.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 5
    throttling_rate_limit  = 2
  }
}

resource "aws_lambda_permission" "api" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.triage.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.tickets.execution_arn}/$default/POST/tickets"
}

output "tickets_url" {
  value = "${aws_apigatewayv2_api.tickets.api_endpoint}/tickets"
}