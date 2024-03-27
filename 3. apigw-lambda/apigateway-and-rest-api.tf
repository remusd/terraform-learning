resource "aws_api_gateway_rest_api" "DynamoDBOperations" {
 name = "DynamoDBOperations"
 description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "DynamoDBManager" {
  rest_api_id = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  parent_id   = "${aws_api_gateway_rest_api.DynamoDBOperations.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  resource_id   = "${aws_api_gateway_resource.DynamoDBManager.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda-https-function.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  resource_id   = "${aws_api_gateway_rest_api.DynamoDBOperations.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda-https-function.invoke_arn}"
}

resource "aws_api_gateway_deployment" "my_api_gateway" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = "${aws_api_gateway_rest_api.DynamoDBOperations.id}"
  stage_name  = "lambda-http-test"
}