# ============================================================================
# AWS Configuration
# ============================================================================
aws_region          = "ap-southeast-7"
expected_account_id = "065209282787" # Add your AWS account ID for safety

# ============================================================================
# Environment  
# ============================================================================
customer_name = "demo-hcm11-1"
environment   = "prod"
site_name     = "HCM11.1 Demo Production"

# ============================================================================
# Network Configuration
# ============================================================================
vpc_cidr           = "172.19.0.0/16"
create_nat_gateway = true

# ============================================================================
# Domain & DNS
# ============================================================================
domain_name        = "demo-hcm11.1.peopleplushcm.com"
create_hosted_zone = true
frontend_domain    = "" # Empty for naked domain (https://demo-hcm11.1.peopleplushcm.com)
backend_domain     = "api.demo-hcm11.1.peopleplushcm.com"

# ============================================================================
# Frontend EC2
# ============================================================================
frontend_instance_type    = "t3.large"
frontend_ami              = "" # Latest Amazon Linux 2
frontend_key_name         = "EC2-Sandbox-TH"
frontend_root_volume_size = 100

# ============================================================================
# Backend EC2 & Auto Scaling
# ============================================================================
create_backend_base      = true # Create base instance first
backend_instance_type    = "t3.large"
backend_ami              = "" # Latest Amazon Linux 2
backend_key_name         = "EC2-Sandbox-TH"
backend_min_size         = 0 # Min ASG size
backend_max_size         = 4 # Max ASG size
backend_desired_size     = 1 # Desired ASG size
backend_root_volume_size = 100

# ============================================================================
# RDS Oracle Database
# ============================================================================
create_rds                = true # ← เปลี่ยนเป็น false ถ้าไม่ต้องการ RDS
rds_instance_class        = "db.m7i.large"
rds_engine_version        = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
rds_allocated_storage     = 200
rds_max_allocated_storage = 500

rds_database_name   = "HCM11_1"
rds_master_username = "admin"
rds_master_password = "ChangeMe123!SecurePassword" # CHANGE THIS!

rds_publicly_accessible     = true
rds_multi_az                = false
rds_backup_retention_period = 7
rds_backup_window           = "03:00-04:00"         # UTC
rds_maintenance_window      = "sun:04:00-sun:05:00" # UTC
rds_deletion_protection     = true
rds_skip_final_snapshot     = false

# ============================================================================
# Load Balancer
# ============================================================================
alb_deletion_protection = false # Production should enable this

# ============================================================================
# Auto Scaling Policies
# ============================================================================
cpu_scale_out_threshold    = 70  # CPU % to scale out
memory_scale_out_threshold = 80  # Memory % to scale out
scale_evaluation_periods   = 2   # 2 periods of 5 min = 10 min
scale_cooldown             = 300 # 5 minutes between scaling
