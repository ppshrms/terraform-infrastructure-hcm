# ============================================================================
# AWS Configuration
# ============================================================================
aws_region          = "ap-southeast-1"
expected_account_id = "" # ← ใส่ AWS Account ID ของ customer

# ============================================================================
# Environment  
# ============================================================================
customer_name = "CUSTOMER_NAME" # ← เปลี่ยนเป็นชื่อ customer
environment   = "uat"
site_name     = "CUSTOMER_NAME UAT"

# ============================================================================
# Network Configuration
# ============================================================================
vpc_cidr = "172.17.0.0/16" # ← ใช้ CIDR แยกจาก prod

# ============================================================================
# Domain & DNS
# ============================================================================
domain_name     = "uat-CUSTOMER.peopleplushcm.com"     # ← Frontend domain (uat-xxx)
frontend_domain = ""                                   # Empty for naked domain
backend_domain  = "api.uat-CUSTOMER.peopleplushcm.com" # ← Backend = api.uat-xxx

# ============================================================================
# Frontend EC2
# ============================================================================
frontend_instance_type    = "t3.small" # UAT: Instance เล็กกว่า prod
frontend_ami              = ""         # Latest Amazon Linux 2
frontend_key_name         = "EC2-Sandbox-TH"
frontend_root_volume_size = 30 # UAT: Disk เล็กกว่า prod

# ============================================================================
# Backend EC2 & Auto Scaling
# ============================================================================
create_backend_base      = true       # Create base instance first
backend_instance_type    = "t3.small" # UAT: Instance เล็กกว่า prod
backend_ami              = ""         # Latest Amazon Linux 2
backend_key_name         = "EC2-Sandbox-TH"
backend_min_size         = 0  # Min ASG size
backend_max_size         = 2  # UAT: Max 2 (prod = 4)
backend_desired_size     = 1  # Desired ASG size
backend_root_volume_size = 30 # UAT: Disk เล็กกว่า prod

# ============================================================================
# RDS Oracle Database
# ============================================================================
create_rds                = true           # ← เปลี่ยนเป็น false ถ้าไม่ต้องการ RDS
rds_instance_class        = "db.t3.medium" # UAT: Instance เล็กกว่า prod
rds_engine_version        = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
rds_allocated_storage     = 100 # UAT: Storage น้อยกว่า prod
rds_max_allocated_storage = 200 # UAT: Max storage น้อยกว่า

rds_database_name   = "HCMDB"
rds_master_username = "admin"
rds_master_password = "ChangeMe123!SecurePassword" # ← CHANGE THIS!

rds_publicly_accessible     = true
rds_multi_az                = false                 # UAT: Single-AZ ลดค่าใช้จ่าย
rds_backup_retention_period = 3                     # UAT: Backup retention สั้นกว่า
rds_backup_window           = "03:00-04:00"         # UTC
rds_maintenance_window      = "sun:04:00-sun:05:00" # UTC
rds_deletion_protection     = false                 # UAT: ไม่ต้อง deletion protection
rds_skip_final_snapshot     = true                  # UAT: Skip final snapshot
rds_availability_zone       = ""                    # ← เช่น "ap-southeast-1a" (ว่าง = AWS เลือกให้)

# ============================================================================
# Load Balancer
# ============================================================================
alb_deletion_protection = false # UAT: ไม่ต้อง deletion protection

# ============================================================================
# Auto Scaling Policies
# ============================================================================
cpu_scale_out_threshold    = 80  # CPU % to scale out
memory_scale_out_threshold = 80  # Memory % to scale out
scale_evaluation_periods   = 2   # 2 periods of 5 min = 10 min
scale_cooldown             = 300 # 5 minutes between scaling

# ============================================================================
# SES Email (Optional)
# ============================================================================
create_ses         = true
ses_email_identity = "noreply@peopleplushcm.com"
