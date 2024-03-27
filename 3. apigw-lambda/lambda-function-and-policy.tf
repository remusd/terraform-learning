data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_dynamodb_access" {
  statement {
    actions = [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_dynamodb_access" {
  name        = "lambda_dynamodb_access"
  description = "lambda_dynamodb_access"
  policy      = data.aws_iam_policy_document.lambda_dynamodb_access.json
}

resource "aws_iam_role" "lambda_function_role" {
  name               = "lambda_function_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_cloudfront" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_dynamodb" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_access.arn
}

resource "aws_lambda_function" "lambda-https-function" {
  filename         = "lambda_function.zip"
  function_name    = "lambda-https-function"
  handler          = "LambdaFunctionOverHttps.handler"
  role             = "${aws_iam_role.lambda_function_role.arn}"
  runtime          = "python3.9"
  source_code_hash = "${filebase64sha256("lambda_function.zip")}"
}