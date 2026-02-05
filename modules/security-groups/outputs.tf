output "alb_sg_id" {
  description = "ID of ALB security group"
  value       = aws_security_group.alb.id
}

output "frontend_sg_id" {
  description = "ID of Frontend EC2 security group"
  value       = aws_security_group.frontend.id
}

output "backend_sg_id" {
  description = "ID of Backend EC2 security group"
  value       = aws_security_group.backend.id
}


output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}
