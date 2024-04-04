resource "aws_dynamodb_table" "employees" {

  name         = "employees"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "employee_id"

  attribute {
    name = "employee_id"
    type = "S"
  }

  attribute {
    name = "business_unit"
    type = "S"
  }

  attribute {
    name = "cubicle_no"
    type = "N"
  }

  # The global secondary index allows us to fetch Employee data
  # belonging to a given BU, sorted by their cubicle number
  global_secondary_index {
    name            = "EmployeeBULocationIndex"
    hash_key        = "business_unit"
    range_key       = "cubicle_no"
    projection_type = "INCLUDE"
    non_key_attributes = ["name"]
  }
}