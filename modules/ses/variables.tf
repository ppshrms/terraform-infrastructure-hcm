# SES Module - Variables

variable "customer_name" {
  description = "Customer/company name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod, dev, staging)"
  type        = string
}

variable "email_identity" {
  description = "Email address or domain to verify in SES (e.g., 'noreply@example.com' or 'example.com')"
  type        = string
}

variable "aws_region" {
  description = "AWS region for SES SMTP endpoint"
  type        = string
  default     = "ap-southeast-1"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
