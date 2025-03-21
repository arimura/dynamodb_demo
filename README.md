# DynamoDB Demo

This project demonstrates working with AWS DynamoDB using Go and Terraform.

## Setup

1. Configure AWS credentials:
2. Create the DynamoDB table using Terraform:
   ```
   make tf-apply
   ```

## Tools

### import-uuids

A command-line tool that reads UUIDs from a file and inserts them into a DynamoDB table.

#### Usage

```
make run-import-uuids
```
