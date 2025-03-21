package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

func main() {
	// Parse command-line arguments
	filePath := flag.String("file", "", "Path to the file containing UUIDs (required)")
	tableName := flag.String("table", "", "DynamoDB table name (required)")
	flag.Parse()

	// Validate required arguments
	if *filePath == "" || *tableName == "" {
		fmt.Println("Error: Both -file and -table arguments are required")
		flag.Usage()
		os.Exit(1)
	}

	// Extract filename from the file path (to use as sort key)
	fileName := filepath.Base(*filePath)

	// Load AWS configuration
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		fmt.Printf("Error loading AWS configuration: %v\n", err)
		os.Exit(1)
	}

	// Create DynamoDB client
	client := dynamodb.NewFromConfig(cfg)

	// Read UUIDs from file
	uuids, err := readUUIDsFromFile(*filePath)
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Found %d UUIDs in file %s\n", len(uuids), *filePath)

	// Insert UUIDs into DynamoDB
	successCount := 0
	for _, uuid := range uuids {
		err := insertIntoDynamoDB(client, *tableName, uuid, fileName)
		if err != nil {
			fmt.Printf("Error inserting UUID %s: %v\n", uuid, err)
			continue
		}
		successCount++
	}

	fmt.Printf("Successfully inserted %d/%d UUIDs into table %s\n", successCount, len(uuids), *tableName)
}

// readUUIDsFromFile reads UUIDs from a file, one per line
func readUUIDsFromFile(filePath string) ([]string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var uuids []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" {
			uuids = append(uuids, line)
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return uuids, nil
}

// insertIntoDynamoDB inserts a UUID into the DynamoDB table
func insertIntoDynamoDB(client *dynamodb.Client, tableName, uuid, fileName string) error {
	item := map[string]types.AttributeValue{
		"ifa": &types.AttributeValueMemberS{
			Value: uuid,
		},
		"seg_name": &types.AttributeValueMemberS{
			Value: fileName,
		},
		"value": &types.AttributeValueMemberBOOL{
			Value: true,
		},
	}

	_, err := client.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String(tableName),
		Item:      item,
	})

	return err
}
