provider "aws" {
  region = "us-east-1" 
}

resource "aws_dynamodb_table" "segment_sample" {
  name           = "segment_sample"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "ifa"
  range_key      = "seg_name"  // Adding sort key

  attribute {
    name = "ifa"
    type = "S"
  }

  attribute {
    name = "seg_name"
    type = "S"
  }

  tags = {
    Name        = "segment_sample"
    Environment = var.environment
  }
}
