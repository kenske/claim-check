variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "prefix" {
  description = "Only objects with this bucket prefix will trigger an SQS notification"
  default     = "uploads/"
}
