resource "aws_api_gateway_rest_api" "maas2" {
  name        = "MAAS2"
  description = "MAAS2 API"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id = aws_api_gateway_rest_api.maas2.id
  stage_name = "PROD"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.maas2.id

  depends_on = [
    aws_api_gateway_method.latest,
    aws_api_gateway_method.what_to_get
  ]
}

resource "aws_lambda_permission" "maas2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.maas2.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration" "latest" {
  rest_api_id             = aws_api_gateway_rest_api.maas2.id
  resource_id             = aws_api_gateway_rest_api.maas2.root_resource_id
  http_method             = aws_api_gateway_method.latest.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "latest" {
  rest_api_id   = aws_api_gateway_rest_api.maas2.id
  resource_id   = aws_api_gateway_rest_api.maas2.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "what_to_get" {
  parent_id = aws_api_gateway_rest_api.maas2.root_resource_id
  path_part = "{whatToGet}"
  rest_api_id = aws_api_gateway_rest_api.maas2.id
}

resource "aws_api_gateway_integration" "what_to_get" {
  rest_api_id             = aws_api_gateway_rest_api.maas2.id
  resource_id             = aws_api_gateway_resource.what_to_get.id
  http_method             = aws_api_gateway_method.what_to_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "what_to_get" {
  rest_api_id   = aws_api_gateway_rest_api.maas2.id
  http_method   = "GET"
  authorization = "NONE"
  resource_id   = aws_api_gateway_resource.what_to_get.id
  request_parameters = {
    "method.request.path.whatToGet" = true
  }
}