# S3 Module - Main Configuration

# S3 Bucket for Database Data Storage
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      Name    = var.bucket_name
      Purpose = "Database data storage and backups"
    }
  )
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "main" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Policy (delete old versions)
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count  = var.lifecycle_days > 0 ? 1 : 0
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_days
    }
  }

  rule {
    id     = "delete-old-backups"
    status = "Enabled"

    filter {
      prefix = "backups/"
    }

    expiration {
      days = var.backup_retention_days
    }
  }
}

# Bucket Policy - Allow access from VPC Endpoint (if provided)
resource "aws_s3_bucket_policy" "main" {
  count  = var.vpc_id != "" ? 1 : 0
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowVPCAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.allowed_role_arns
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
      }
    ]
  })
}

# ============================================================================
# Upload Oracle Wallet file (cwallet.sso)
# ============================================================================
resource "aws_s3_object" "cwallet" {
  count  = var.upload_wallet_file ? 1 : 0
  bucket = aws_s3_bucket.main.id
  key    = "wallet/cwallet.sso"
  source = "${path.module}/cwallet.sso"
  etag   = filemd5("${path.module}/cwallet.sso")

  tags = merge(
    var.tags,
    {
      Name    = "Oracle Wallet"
      Purpose = "Database connectivity wallet"
    }
  )
}

# VPC Endpoint for S3 (optional - for private access without NAT Gateway)
resource "aws_vpc_endpoint" "s3" {
  count        = var.create_vpc_endpoint && var.vpc_id != "" ? 1 : 0
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = var.route_table_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.bucket_name}-vpc-endpoint"
    }
  )
}
