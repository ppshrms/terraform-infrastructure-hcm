# AWS Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "expected_account_id" {
  description = "Expected AWS Account ID (for safety validation, leave empty to skip)"
  type        = string
  default     = ""
}

# Customer & Environment
variable "customer_name" {
  description = "Customer name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, staging, dev)"
  type        = string
}

variable "site_name" {
  description = "Site display name"
  type        = string
}

# Networking
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "create_nat_gateway" {
  description = "Whether to create NAT gateway"
  type        = bool
  default     = true
}



# Domain & DNS
variable "domain_name" {
  description = "Base domain name"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a new hosted zone"
  type        = bool
  default     = true
}

variable "frontend_domain" {
  description = "Frontend domain (empty for naked domain)"
  type        = string
  default     = ""
}

variable "backend_domain" {
  description = "Backend API domain"
  type        = string
}

# Frontend EC2
variable "frontend_instance_type" {
  description = "Frontend EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "frontend_ami" {
  description = "Frontend AMI ID (empty for latest Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "frontend_key_name" {
  description = "Frontend SSH key pair name"
  type        = string
}

variable "frontend_root_volume_size" {
  description = "Frontend root volume size in GB"
  type        = number
  default     = 30
}

# Backend EC2 & Auto Scaling
variable "create_backend_base" {
  description = "Whether to create the base backend instance (for initial setup)"
  type        = bool
  default     = true
}

variable "backend_instance_type" {
  description = "Backend EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "backend_ami" {
  description = "Backend AMI ID (empty for latest Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "backend_key_name" {
  description = "Backend SSH key pair name"
  type        = string
}

variable "backend_min_size" {
  description = "Backend ASG minimum size"
  type        = number
  default     = 1
}

variable "backend_max_size" {
  description = "Backend ASG maximum size"
  type        = number
  default     = 4
}

variable "backend_desired_size" {
  description = "Backend ASG desired size"
  type        = number
  default     = 1
}

variable "backend_root_volume_size" {
  description = "Backend root volume size in GB"
  type        = number
  default     = 30
}

# Auto Scaling Policies
variable "cpu_scale_out_threshold" {
  description = "CPU percentage threshold to trigger scale out"
  type        = number
  default     = 80
}

variable "memory_scale_out_threshold" {
  description = "Memory percentage threshold to trigger scale out"
  type        = number
  default     = 80
}

variable "scale_evaluation_periods" {
  description = "Number of periods (5 min each) to evaluate before scaling"
  type        = number
  default     = 1
}

variable "scale_cooldown" {
  description = "Cooldown period in seconds between scaling activities"
  type        = number
  default     = 300
}



# ALB Configuration
variable "alb_deletion_protection" {
  description = "Enable deletion protection on ALB"
  type        = bool
  default     = false
}

# ============================================================================
# RDS Oracle Configuration
# ============================================================================
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_engine_version" {
  description = "Oracle engine version"
 type        = string
  default     = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
}

variable "rds_allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 100
}

variable "rds_max_allocated_storage" {
  description = "Maximum storage for autoscaling in GB"
  type        = number
  default     = 500
}

variable "rds_database_name" {
  description = "Database name"
  type        = string
}

variable "rds_master_username" {
  description = "Master username"
  type        = string
}

variable "rds_master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "rds_publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_backup_window" {
  description = "Backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "Maintenance window (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}
