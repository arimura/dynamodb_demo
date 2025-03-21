provider "aws" {
  region = "us-east-1" 
}

resource "aws_dynamodb_table" "segment_sample" {
  name           = "segment_sample"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "ifa"

  attribute {
    name = "ifa"
    type = "S"
  }

  tags = {
    Name        = "segment_sample"
    Environment = var.environment
  }
}
