# ============================================================================
# Phase 1 Infrastructure Outputs
# ============================================================================

# Account Information
output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

# ============================================================================
# Networking Outputs
# ============================================================================
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.networking.vpc_cidr
}

# ============================================================================
# Route53 Outputs
# ============================================================================
output "route53_zone_id" {
  description = "Route53 hosted zone ID (for Phase 2)"
  value       = local.hosted_zone_id
}

output "route53_zone_name" {
  description = "Route53 hosted zone name"
  value       = var.domain_name
}

output "route53_name_servers" {
  description = "Route53 name servers (update these at your domain registrar)"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

# ============================================================================
# ALB Outputs (CRITICAL for Phase 2)
# ============================================================================
output "alb_arn" {
  description = "ALB ARN (required for Phase 2 HTTPS listener)"
  value       = module.alb.frontend_alb_arn
}

output "alb_dns_name" {
  description = "ALB DNS name - Use this for manual DNS setup before Phase 2"
  value       = module.alb.frontend_alb_dns
}

output "alb_zone_id" {
  description = "ALB hosted zone ID (for Route53 ALIAS records in Phase 2)"
  value       = module.alb.frontend_alb_zone_id
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN (for Phase 2 HTTPS listener)"
  value       = module.alb.frontend_target_group_arn
}

output "backend_target_group_arn" {
  description = "Backend target group ARN (for Phase 2 HTTPS listener)"
  value       = module.alb.backend_target_group_arn
}

# ============================================================================
# EC2 Outputs
# ============================================================================
output "frontend_instance_id" {
  description = "Frontend EC2 instance ID"
  value       = module.frontend.instance_id
}

output "backend_asg_name" {
  description = "Backend Auto Scaling Group name"
  value       = module.backend.asg_name
}


# ============================================================================
# SSH Keys Outputs
# ============================================================================
output "frontend_key_name" {
  description = "Frontend SSH key pair name"
  value       = aws_key_pair.frontend.key_name
}

output "backend_key_name" {
  description = "Backend SSH key pair name"
  value       = aws_key_pair.backend.key_name
}

output "ssh_private_key_location" {
  description = "Location of generated SSH private keys"
  value       = "${path.module}/ssh-keys/"
}

# ============================================================================
# Next Steps for Phase 2
# ============================================================================
output "next_steps" {
  description = "Instructions for Phase 2 deployment"
  value       = <<-EOT
    ✅ Phase 1 Complete!
    
    📋 Next Steps:
    1. Test HTTP access: http://${module.alb.frontend_alb_dns}
    2. (Optional) Manually update DNS to point to ALB
    3. Navigate to: cd ../phase2-dns-ssl
    4. Run: terraform init
    5. Run: terraform apply
    
    🔐 SSH Access:
    - Frontend: ssh -i ssh-keys/${var.customer_name}-frontend-key.pem ec2-user@<instance-ip>
    - Backend:  ssh -i ssh-keys/${var.customer_name}-backend-key.pem ec2-user@<instance-ip>
    
    📊 ALB DNS Name: ${module.alb.frontend_alb_dns}
  EOT
}
