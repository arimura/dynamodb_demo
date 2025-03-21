# Makefile for AWS DynamoDB operations

# Default AWS region
AWS_REGION ?= us-east-1

# List all DynamoDB tables in the specified AWS region
list-dynamodb-tables:
	@echo "Listing DynamoDB tables in region: $(AWS_REGION)"
	aws dynamodb list-tables --region $(AWS_REGION)

# Help target
help:
	@echo "Available targets:"
	@echo "  list-dynamodb-tables - List all DynamoDB tables in the specified AWS region"
	@echo ""
	@echo "Parameters:"
	@echo "  AWS_REGION - AWS region to use (default: us-east-1)"
	@echo ""
	@echo "Example usage:"
	@echo "  make list-dynamodb-tables"
	@echo "  make list-dynamodb-tables AWS_REGION=us-west-2"

.PHONY: list-dynamodb-tables help
