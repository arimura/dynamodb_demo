# Makefile for AWS DynamoDB operations

# Default AWS region
AWS_REGION ?= us-east-1
TABLE_NAME ?= "segment_sample"
SAMPLE_FILE ?= "data/sample-segmet1.csv"

# Run targets
run-import-uuids:
	@echo "Running import-uuids tool with sample data..."
	go run ./cmd/import-uuids -file $(SAMPLE_FILE) -table $(TABLE_NAME)

# List all DynamoDB tables in the specified AWS region
list-dynamodb-tables:
	@echo "Listing DynamoDB tables in region: $(AWS_REGION)"
	aws dynamodb list-tables --region $(AWS_REGION)

drop-dynamodb-table:
	@echo "Dropping DynamoDB table in region: $(AWS_REGION)"
	aws dynamodb delete-table --table-name $(TABLE_NAME) --region $(AWS_REGION)
 
tf-apply:
	cd terraform && terraform init && terraform apply
	cd ..

# Help target
help:
	@echo "Available targets:"
	@echo "  list-dynamodb-tables - List all DynamoDB tables in the specified AWS region"
	@echo "  run-import-uuids - Run the import-uuids tool with sample data"
	@echo "  tf-apply - Apply Terraform configuration to create DynamoDB table"
	@echo "  drop-dynamodb-table - Delete the DynamoDB table"
	@echo ""
	@echo "Parameters:"
	@echo "  AWS_REGION - AWS region to use (default: us-east-1)"
	@echo "  TABLE_NAME - DynamoDB table name (default: segment_sample)"
	@echo "  SAMPLE_FILE - Sample data file path (default: data/sample-segmet1.csv)"
	@echo ""
	@echo "Example usage:"
	@echo "  make list-dynamodb-tables"
	@echo "  make run-import-uuids"
	@echo "  make run-import-uuids TABLE_NAME=my_table SAMPLE_FILE=data/other-file.csv"

.PHONY: list-dynamodb-tables run-import-uuids tf-apply drop-dynamodb-table help
