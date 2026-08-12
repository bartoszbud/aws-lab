resource "aws_s3_bucket" "state" {
  bucket_prefix = "${var.environment}-${var.module_name}-state-"
  force_destroy = false

  tags = {
    Environment = var.environment
    Purpose     = "TF state bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "state_public_access_block" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }  
}

resource "aws_s3_bucket_lifecycle_configuration" "state_bucket_lifecycle" {
  bucket = aws_s3_bucket.state.id

  rule {
    id = "expire-old-versions"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_logging" "name" {
  bucket = aws_s3_bucket.state.id

  target_bucket = aws_s3_bucket.state_logs.id
  target_prefix = "logs/"
}


resource "aws_s3_bucket" "state_logs" {
  bucket_prefix = "${var.environment}-${var.module_name}-state-logs-"
  force_destroy = false

  tags = {
    Environment = var.environment
    Purpose     = "TF state bucket logs"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_logs_encryption" {
  bucket = aws_s3_bucket.state_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state_logs_public_access_block" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "state_bucket_lifecycle" {
  bucket = aws_s3_bucket.state.id

  rule {
    id = "expire-old-versions"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}