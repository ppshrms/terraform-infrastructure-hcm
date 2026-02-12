variable "customer_name" {
  description = "Customer name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, staging, dev)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "s3_bucket_arn" {
  description = "ARN of S3 bucket to grant access to (optional)"
  type        = string
  default     = ""
}
