output "frontend_alb_id" {
  description = "ID of Frontend ALB"
  value       = aws_lb.frontend.id
}

output "frontend_alb_arn" {
  description = "ARN of Frontend ALB"
  value       = aws_lb.frontend.arn
}

output "frontend_alb_dns" {
  description = "DNS name of Frontend ALB"
  value       = aws_lb.frontend.dns_name
}

output "frontend_alb_zone_id" {
  description = "Zone ID of Frontend ALB"
  value       = aws_lb.frontend.zone_id
}

output "frontend_target_group_arn" {
  description = "ARN of Frontend target group"
  value       = aws_lb_target_group.frontend.arn
}

output "backend_alb_id" {
  description = "ID of Backend ALB"
  value       = aws_lb.backend.id
}

output "backend_alb_arn" {
  description = "ARN of Backend ALB"
  value       = aws_lb.backend.arn
}

output "backend_alb_dns" {
  description = "DNS name of Backend ALB"
  value       = aws_lb.backend.dns_name
}

output "backend_alb_zone_id" {
  description = "Zone ID of Backend ALB"
  value       = aws_lb.backend.zone_id
}

output "backend_target_group_arn" {
  description = "ARN of Backend target group"
  value       = aws_lb_target_group.backend.arn
}
