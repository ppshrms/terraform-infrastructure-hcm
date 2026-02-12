# ============================================================================
# AWS Configuration
# ============================================================================
aws_region          = "ap-southeast-1"
expected_account_id = "" # Add your AWS account ID for safety

# ============================================================================
# Environment  
# ============================================================================
customer_name = "demo-hcm11-1"
environment   = "prod"
site_name     = "HCM Demo Production"

# ============================================================================
# Network Configuration
# ============================================================================
vpc_cidr           = "172.17.0.0/16"
create_nat_gateway = true

# ============================================================================
# Domain & DNS
# ============================================================================
domain_name        = "demo-hcm11-1.peopleplushcm.com"
create_hosted_zone = true
frontend_domain    = "" # Empty for naked domain (demo-hcm11-1.peopleplushcm.com)
backend_domain     = "api.demo-hcm11-1.peopleplushcm.com"

# ============================================================================
# Frontend EC2
# ============================================================================
frontend_instance_type    = "t3.small"
frontend_ami              = ""                           # Latest Amazon Linux 2
frontend_key_name         = "demo-hcm11-1-prod-frontend" # Auto-generated, for reference only
frontend_root_volume_size = 30

# ============================================================================
# Backend EC2 & Auto Scaling
# ============================================================================
create_backend_base      = true # Create base instance first
backend_instance_type    = "t3.medium"
backend_ami              = ""                          # Latest Amazon Linux 2
backend_key_name         = "demo-hcm11-1-prod-backend" # Auto-generated, for reference only
backend_min_size         = 0                           # Min ASG size
backend_max_size         = 4                           # Max ASG size
backend_desired_size     = 1                           # Desired ASG size
backend_root_volume_size = 30

# ============================================================================
# RDS Oracle Database
# ============================================================================
rds_instance_class        = "db.t3.medium"
rds_engine_version        = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
rds_allocated_storage     = 100
rds_max_allocated_storage = 500

rds_database_name   = "HCMDB"
rds_master_username = "admin"
rds_master_password = "ChangeMe123!SecurePassword" # CHANGE THIS!

rds_publicly_accessible     = false
rds_multi_az                = true
rds_backup_retention_period = 7
rds_backup_window           = "03:00-04:00"         # UTC
rds_maintenance_window      = "sun:04:00-sun:05:00" # UTC
rds_deletion_protection     = true
rds_skip_final_snapshot     = false

# ============================================================================
# Load Balancer
# ============================================================================
alb_deletion_protection = true # Production should enable this

# ============================================================================
# Auto Scaling Policies
# ============================================================================
cpu_scale_out_threshold    = 70  # CPU % to scale out
memory_scale_out_threshold = 80  # Memory % to scale out
scale_evaluation_periods   = 2   # 2 periods of 5 min = 10 min
scale_cooldown             = 300 # 5 minutes between scaling

# ============================================================================
# SES SMTP (Optional - for sending emails)
# ============================================================================
ses_email_identity = "" # PRODUCTION: Set to "noreply@yourcompany.com" or domain

# ============================================================================
# Custom Database Endpoint (Optional)
# ============================================================================
create_custom_db_endpoint = true # Production: Enable custom DB endpoint
