resource "aws_s3_bucket" "heliumedu" {
  bucket = "heliumedu-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.heliumedu.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "allow_ses_ci_dump" {
  statement {
    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::heliumedu-${var.environment}/ci.email/*",
    ]

    condition = {
      test = "StringEquals"
      variable = "\"aws:Referer\": \"${var.aws_account_id}\""
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.heliumedu.id
  policy = data.aws_iam_policy_document.allow_ses_ci_dump.json
}