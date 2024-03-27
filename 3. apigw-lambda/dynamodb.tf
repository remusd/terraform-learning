resource "aws_dynamodb_table" "lambda-apigateway" {
  name         = "lambda-apigateway"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}