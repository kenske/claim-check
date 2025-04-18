variable "aws_profile" {}

variable "env" {
  description = "Environment name"
  default     = "testing"
}

variable "prefix" {
  description = "Only objects with this bucket prefix will trigger an SQS notification"
  default     = "uploads/"
}

variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  default = "claim-check-testing-payloads"
}

variable "queue_name" {
  description = "The name of the SQS queue"
  default     = "claim-check"
}

