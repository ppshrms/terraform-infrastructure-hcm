# S3 Module - Outputs

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name (for direct access)"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint (if created)"
  value       = var.create_vpc_endpoint && var.vpc_id != "" ? aws_vpc_endpoint.s3[0].id : null
}
