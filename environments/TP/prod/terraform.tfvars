# ============================================================================
# AWS Configuration
# ============================================================================
aws_region          = "ap-southeast-1"
expected_account_id = "" # ← ใส่ AWS Account ID ของ customer

# ============================================================================
# Environment  
# ============================================================================
customer_name = "CUSTOMER_NAME" # ← เปลี่ยนเป็นชื่อ customer
environment   = "prod"
site_name     = "CUSTOMER_NAME Production"

# ============================================================================
# Network Configuration
# ============================================================================
vpc_cidr = "172.16.0.0/16"

# ============================================================================
# Domain & DNS
# ============================================================================
domain_name     = "demo-CUSTOMER.peopleplushcm.com"     # ← Frontend domain
frontend_domain = ""                                    # Empty for naked domain
backend_domain  = "api.demo-CUSTOMER.peopleplushcm.com" # ← Backend = api.demo-xxx

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

rds_database_name   = "HCMDB"
rds_master_username = "admin"
rds_master_password = "ChangeMe123!SecurePassword" # ← CHANGE THIS!

rds_publicly_accessible     = true
rds_multi_az                = true # Production: Multi-AZ enabled
rds_backup_retention_period = 7
rds_backup_window           = "03:00-04:00"         # UTC
rds_maintenance_window      = "sun:04:00-sun:05:00" # UTC
rds_deletion_protection     = true
rds_skip_final_snapshot     = false
rds_availability_zone       = "" # ← เช่น "ap-southeast-1a" (ว่าง = AWS เลือกให้)

# ============================================================================
# Load Balancer
# ============================================================================
alb_deletion_protection = true # Production: Enable deletion protection

# ============================================================================
# Auto Scaling Policies
# ============================================================================
cpu_scale_out_threshold    = 70  # CPU % to scale out
memory_scale_out_threshold = 80  # Memory % to scale out
scale_evaluation_periods   = 2   # 2 periods of 5 min = 10 min
scale_cooldown             = 300 # 5 minutes between scaling

# ============================================================================
# SES Email (Optional - สำหรับส่ง email)
# ============================================================================
create_ses         = true                        # ← true = สร้าง SMTP user
ses_email_identity = "noreply@peopleplushcm.com" # ← email หรือ domain
