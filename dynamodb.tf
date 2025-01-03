# Create the DynamoDB Table for proceesed data
resource "aws_dynamodb_table" "insights_table" {
  name         = "insights_table"
  billing_mode = "PAY_PER_REQUEST"
  #read_capacity  = 20
  #write_capacity = 20
  hash_key = "timestamp"

  attribute {
    name = "timestamp"
    type = "S"
  }
}

