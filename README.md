<!-- BEGIN_TF_DOCS -->
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.payloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.payloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_public_access_block.payloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.payloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_sqs_queue.payloads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.payloads_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3_to_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Only objects with this bucket prefix will trigger an SQS notification | `string` | `"uploads/"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the SQS queue | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_url"></a> [sqs\_url](#output\_sqs\_url) | The URL of the SQS queue |
<!-- END_TF_DOCS -->