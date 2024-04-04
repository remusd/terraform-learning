# Create Lambda function using Python script
resource "aws_lambda_function" "new_employee_handler" {
  function_name = "new_employee_handler"
  filename      = "./lambda/lambda_function.zip"
  handler       = "add_employee.lambda_handler"
  runtime       = "python3.8"

  source_code_hash  = filebase64sha256("./lambda/lambda_function.zip")
  role              = aws_iam_role.assume_lambda_role.arn
  timeout           = "60"
}

# Create IAM role for Lambda
resource "aws_iam_role" "assume_lambda_role" {
  name               = "assume_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow"
    }
  ]
}
EOF
}

# This is only to allow grabbing the current region and account ID
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Create IAM policy to allow Lambda to insert records into DynamoDB table "employees"
data "aws_iam_policy_document" "lambda_insert_dynamodb" {
    statement {
     sid = "1"
     actions = [ "dynamodb:PutItem" ]
     resources = [ "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/employees" ]
   }
}

resource "aws_iam_policy" "lambda_insert_dynamodb_policy" {
 name   = "LambdaInsertDynamoDB"
 policy = data.aws_iam_policy_document.lambda_insert_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.assume_lambda_role.name
  policy_arn = aws_iam_policy.lambda_insert_dynamodb_policy.arn
}

# Grant permission to the API gateway to invoke the Lambda function
resource "aws_lambda_permission" "allow_api_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.new_employee_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.employee_api_gw.execution_arn}/*/POST/employee"
}