# S3 Module - Variables

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "lifecycle_days" {
  description = "Number of days to keep old object versions (0 = disabled)"
  type        = number
  default     = 90
}

variable "backup_retention_days" {
  description = "Number of days to keep backups under backups/ prefix"
  type        = number
  default     = 30
}

variable "vpc_id" {
  description = "VPC ID for VPC endpoint (optional)"
  type        = string
  default     = ""
}

variable "route_table_ids" {
  description = "Route table IDs for VPC endpoint"
  type        = list(string)
  default     = []
}

variable "create_vpc_endpoint" {
  description = "Create VPC endpoint for S3 (for private access)"
  type        = bool
  default     = false
}

variable "allowed_role_arns" {
  description = "List of IAM role ARNs allowed to access the bucket"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "upload_wallet_file" {
  description = "Upload Oracle Wallet file (cwallet.sso) to S3 bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
