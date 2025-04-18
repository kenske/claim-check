terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "> 1.5.7"
}


provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}


module "claim_check" {
  source      = "../../"
  env         = var.env
  bucket_name = var.bucket_name
  queue_name  = var.queue_name
  prefix      = var.prefix
}

moved {
  from = module.payload
  to   = module.claim_check
}