# Terraform Module: claim-check

[![Terraform Version](https://img.shields.io/badge/Terraform-1.0.0+-blue.svg)](https://www.terraform.io/)
[![AWS Provider Version](https://img.shields.io/badge/AWS-5.0+-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Overview

This module creates the following:
- S3 bucket with encryption enabled
- SQS Queue
- S3 notification configuration to send messages to the SQS queue when objects are created in the bucket

## Usage

```hcl
module "claim_check" {
  source = "./path-to-module"

  # Required inputs
  env         = "staging"
  bucket_name = "my-unique-bucket-name"
  queue_name  = "my-queue-name"
  
  # Optional  
  prefix = "uploads/"

}
```