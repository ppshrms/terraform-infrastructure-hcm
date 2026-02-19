output "db_instance_id" {
  description = "RDS instance ID"
  value       = var.create_rds ? aws_db_instance.main[0].id : null
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = var.create_rds ? aws_db_instance.main[0].arn : null
}

output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = var.create_rds ? aws_db_instance.main[0].endpoint : null
}

output "db_address" {
  description = "RDS instance address"
  value       = var.create_rds ? aws_db_instance.main[0].address : null
}

output "db_port" {
  description = "RDS instance port"
  value       = var.create_rds ? aws_db_instance.main[0].port : null
}

output "db_name" {
  description = "Database name"
  value       = var.create_rds ? aws_db_instance.main[0].db_name : null
}

output "db_username" {
  description = "Master username"
  value       = var.create_rds ? aws_db_instance.main[0].username : null
  sensitive   = true
}
