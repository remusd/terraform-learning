# Create the RESTful API
resource "aws_api_gateway_rest_api" "employee_api_gw" {
  name        = "employee_api_gw"
  description = "Employee API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create the /employee path in the API
resource "aws_api_gateway_resource" "employee" {
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  parent_id   = aws_api_gateway_rest_api.employee_api_gw.root_resource_id
  path_part   = "employee"
}

# Specify request methods for the API
resource "aws_api_gateway_method" "add_employee" {
  rest_api_id   = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id   = aws_api_gateway_resource.employee.id
  authorization = "NONE"
  http_method   = "POST"
}

# Integrate/map API with the Lambda function
resource "aws_api_gateway_integration" "new_employee_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.employee_api_gw.id
  resource_id             = aws_api_gateway_method.add_employee.resource_id
  http_method             = aws_api_gateway_method.add_employee.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.new_employee_handler.invoke_arn
}

# Deploy the API to new stage "test"
resource "aws_api_gateway_deployment" "api_stage_test" {
  depends_on = [ aws_api_gateway_integration.new_employee_lambda ]
  
  rest_api_id = aws_api_gateway_rest_api.employee_api_gw.id
  stage_name  = "test"
}