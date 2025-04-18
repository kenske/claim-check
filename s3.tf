resource "aws_s3_bucket" "payloads" {
  bucket = var.bucket_name

  tags = {
    Environment = var.env
    Managed     = "terraform"
  }
}


resource "aws_s3_bucket_public_access_block" "payloads" {
  bucket = aws_s3_bucket.payloads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "payloads" {
  bucket = aws_s3_bucket.payloads.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_notification" "payloads" {
  bucket = aws_s3_bucket.payloads.id

  queue {
    id            = "payload-upload-event"
    queue_arn     = aws_sqs_queue.payloads.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = var.prefix
  }

}