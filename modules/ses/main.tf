# SES Module - Main Configuration

# Email/Domain Identity for SES
resource "aws_ses_email_identity" "main" {
  count = var.email_identity != "" && !can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.email_identity)) ? 1 : 0
  email = var.email_identity
}

resource "aws_ses_domain_identity" "main" {
  count  = var.email_identity != "" && can(regex("^[a-z0-9.-]+\\.[a-z]{2,}$", var.email_identity)) ? 1 : 0
  domain = var.email_identity
}

# IAM User for SMTP Access
resource "aws_iam_user" "smtp" {
  name = "${var.customer_name}-${var.environment}-smtp-user"

  tags = merge(
    var.tags,
    {
      Name    = "${var.customer_name}-${var.environment}-smtp-user"
      Purpose = "SES SMTP Authentication"
    }
  )
}

# IAM Policy for SES Send
resource "aws_iam_user_policy" "ses_send" {
  name = "ses-send-email"
  user = aws_iam_user.smtp.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Access Key for SMTP
resource "aws_iam_access_key" "smtp" {
  user = aws_iam_user.smtp.name
}

# Calculate SMTP Password from Secret Access Key
# AWS SES SMTP password is derived from the secret access key using specific algorithm
# Reference: https://docs.aws.amazon.com/ses/latest/dg/smtp-credentials.html
locals {
  # SMTP endpoint based on region
  smtp_endpoint = "email-smtp.${var.aws_region}.amazonaws.com"

  # Note: Actual SMTP password calculation requires hashicorp/aws provider's built-in function
  # For production use, consider using AWS Secrets Manager instead of outputting password
}
