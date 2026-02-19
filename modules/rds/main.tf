# RDS Oracle Module

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  count = var.create_rds ? 1 : 0

  name       = "${var.customer_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-db-subnet-group"
    }
  )
}

# DB Parameter Group
resource "aws_db_parameter_group" "main" {
  count = var.create_rds ? 1 : 0

  name   = "${var.customer_name}-${var.environment}-oracle-params"
  family = "oracle-se2-19"

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-oracle-params"
    }
  )
}

# RDS Oracle Instance
resource "aws_db_instance" "main" {
  count = var.create_rds ? 1 : 0

  identifier = "${var.customer_name}-${var.environment}-oracle-db"

  # Engine
  engine         = "oracle-se2"
  engine_version = var.engine_version
  license_model  = "license-included"

  # Instance
  instance_class = var.instance_class

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp2"
  iops                  = 0 # Explicitly clear IOPS for gp2 compatibility
  storage_encrypted     = true

  # Database
  db_name  = var.database_name
  username = var.master_username
  password = var.master_password
  port     = 1521

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main[0].name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = var.publicly_accessible

  # High Availability
  multi_az = var.multi_az

  # Backup
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  # Monitoring
  enabled_cloudwatch_logs_exports = ["alert", "audit", "listener", "trace"]
  monitoring_interval             = 60
  monitoring_role_arn             = var.monitoring_role_arn

  # Parameter Group
  parameter_group_name = aws_db_parameter_group.main[0].name

  # Deletion Protection
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.customer_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Performance Insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-oracle-db"
    }
  )

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

