package test

import (
	"bytes"
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"log"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Notifications(t *testing.T) {
	t.Parallel()

	expectedEnvironment := "testing"
	expectedBucketName := "claim-check-testing-payloads"
	expectedObjectName := fmt.Sprintf("test-%s.txt", random.UniqueId())
	prefix := "uploads/"
	awsRegion := "us-east-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/claim-check",
		Vars: map[string]interface{}{
			"env":         expectedEnvironment,
			"prefix":      prefix,
			"bucket_name": expectedBucketName,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	aws.AssertS3BucketExists(t, awsRegion, expectedBucketName)

	defer aws.EmptyS3Bucket(t, awsRegion, expectedBucketName)

	queueUrl := terraform.Output(t, terraformOptions, "sqs_url")
	ClearSQSQueue(t, awsRegion, queueUrl)

	CreateS3Object(t, awsRegion, expectedBucketName, prefix+expectedObjectName)
	message := aws.WaitForQueueMessage(t, awsRegion, queueUrl, 10)

	if message.Error != nil {
		t.Fatalf("Failed to receive message from SQS queue: %s", message.Error)
	}

	assert.Contains(t, message.MessageBody, prefix+expectedObjectName)

}

func CreateS3Object(t *testing.T, region string, bucketId string, objectName string) {
	// Create an S3 object
	uploader := aws.NewS3Uploader(t, region)

	content := "Hello, World!"

	input := &s3.PutObjectInput{
		Bucket: &bucketId,
		Key:    &objectName,
		Body:   bytes.NewReader([]byte(content)),
	}

	_, err := uploader.Upload(context.TODO(), input)

	if err != nil {
		t.Fatalf("Failed to upload object %s to bucket %s: %v", objectName, bucketId, err)
	}

	t.Log(fmt.Sprintf("S3 object %s created in bucket %s", objectName, bucketId))
}

func ClearSQSQueue(t *testing.T, region string, queueUrl string) {

	client := aws.NewSqsClient(t, region)

	// Purge the queue
	_, err := client.PurgeQueue(context.TODO(), &sqs.PurgeQueueInput{
		QueueUrl: &queueUrl,
	})
	if err != nil {
		t.Fatalf("failed to purge SQS queue %s: %s", queueUrl, err)
	}

	log.Printf("Successfully purged SQS queue: %s", queueUrl)
}
