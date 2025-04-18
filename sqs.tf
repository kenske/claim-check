resource "aws_sqs_queue" "payloads" {
  name = var.queue_name

  sqs_managed_sse_enabled = true

  tags = {
    Environment = var.env
    Managed     = "terraform"
  }
}

data "aws_iam_policy_document" "s3_to_sqs" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]

    resources = [aws_sqs_queue.payloads.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.payloads.arn]
    }
  }
  version = "2012-10-17"
}

resource "aws_sqs_queue_policy" "payloads_queue_policy" {
  queue_url = aws_sqs_queue.payloads.id
  policy    = data.aws_iam_policy_document.s3_to_sqs.json
}