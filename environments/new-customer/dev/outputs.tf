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
# ACM Certificate Outputs
# ============================================================================
output "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.main.arn
}

output "acm_dns_validation_records" {
  description = "DNS records to add for ACM certificate validation"
  value = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}

# ============================================================================
# ALB Outputs
# ============================================================================
output "frontend_alb_dns_name" {
  description = "Frontend ALB DNS Name"
  value       = module.alb.frontend_alb_dns
}

output "backend_alb_dns_name" {
  description = "Backend ALB DNS Name"
  value       = module.alb.backend_alb_dns
}

output "alb_arn" {
  description = "Frontend ALB ARN"
  value       = module.alb.frontend_alb_arn
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  value       = module.alb.frontend_target_group_arn
}

output "backend_target_group_arn" {
  description = "Backend target group ARN"
  value       = module.alb.backend_target_group_arn
}

# ============================================================================
# EC2 Outputs
# ============================================================================
output "frontend_instance_id" {
  description = "Frontend EC2 instance ID"
  value       = module.frontend.instance_id
}

output "frontend_public_ip" {
  description = "Frontend EC2 Public IP (Elastic IP)"
  value       = module.frontend.public_ip
}

output "backend_base_instance_id" {
  description = "Backend Base Instance ID"
  value       = module.backend.base_instance_id
}

output "backend_base_public_ip" {
  description = "Backend Base Instance Public IP (Elastic IP)"
  value       = module.backend.base_instance_public_ip
}

output "backend_asg_name" {
  description = "Backend Auto Scaling Group name"
  value       = module.backend.asg_name
}


# ============================================================================
# Next Steps
# ============================================================================
output "next_steps" {
  description = "Instructions for Phase 2 deployment"
  value       = <<-EOT
    ✅ Phase 1 Complete!
    
    📋 DNS Setup:
    1. **Frontend**: CNAME '${var.domain_name}'
       👉 ${module.alb.frontend_alb_dns}
       
    2. **Backend**: CNAME 'api.demo-hcm11...'
       👉 ${module.alb.backend_alb_dns}
       
    3. **SSL Validation**: 
       - Check ACM status. If 'ISSUED', proceed.
       - If 'PENDING_VALIDATION', check your CNAME records.
    
    4. **Enable HTTPS**: 
       - Edit 'main.tf': Set 'enable_https = true'.
       - Run: 'terraform apply'
    
    🔐 SSH Access (Use 'EC2-Sandbox-TH' key):
    - Frontend: ssh -i path/to/EC2-Sandbox-TH.pem ec2-user@${module.frontend.public_ip}
    - Backend Base: ssh -i path/to/EC2-Sandbox-TH.pem ec2-user@${module.backend.base_instance_public_ip}
  EOT
}
