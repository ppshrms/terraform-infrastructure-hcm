# SES Module - Outputs

output "smtp_username" {
  description = "SMTP username (same as IAM access key ID)"
  value       = aws_iam_access_key.smtp.id
}

output "smtp_password" {
  description = "SMTP password (derived from IAM secret access key) - SENSITIVE"
  value       = aws_iam_access_key.smtp.ses_smtp_password_v4
  sensitive   = true
}

output "smtp_endpoint" {
  description = "SES SMTP endpoint for sending emails"
  value       = local.smtp_endpoint
}

output "smtp_port" {
  description = "SMTP port (use 587 for STARTTLS)"
  value       = "587"
}

output "email_identity" {
  description = "Verified email or domain identity"
  value       = var.email_identity
}

output "iam_user_arn" {
  description = "ARN of the IAM user created for SMTP"
  value       = aws_iam_user.smtp.arn
}
