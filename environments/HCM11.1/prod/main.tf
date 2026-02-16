terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "HCM"
      Customer    = var.customer_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Phase       = "Infrastructure"
    }
  }
}

# Get current AWS account information
data "aws_caller_identity" "current" {}

# Validate AWS Account ID to prevent deploying to wrong account
resource "null_resource" "validate_account" {
  count = var.expected_account_id != "" ? 1 : 0

  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command     = <<-EOT
      if ("${data.aws_caller_identity.current.account_id}" -ne "${var.expected_account_id}") {
        Write-Error "ERROR: Deploying to wrong AWS account!"
        Write-Host "Expected Account ID: ${var.expected_account_id}"
        Write-Host "Current Account ID:  ${data.aws_caller_identity.current.account_id}"
        Write-Host "Current User ARN:    ${data.aws_caller_identity.current.arn}"
        exit 1
      }
      Write-Host "Correct AWS Account: ${data.aws_caller_identity.current.account_id}"
    EOT
  }

  triggers = {
    account_check = data.aws_caller_identity.current.account_id
  }
}

locals {
  common_tags = {
    Customer    = var.customer_name
    Environment = var.environment
  }
}

# ============================================================================
# SSH Key Pair - Using existing key pair (EC2-Sandbox-TH)
# ============================================================================
# No auto-generated keys - using existing key pair specified in terraform.tfvars

# ============================================================================
# IAM Module
# ============================================================================
module "iam" {
  source = "../../../modules/iam"

  customer_name = var.customer_name
  environment   = var.environment
  tags          = local.common_tags
}

# ============================================================================
# Networking Module
# ============================================================================
module "networking" {
  source = "../../../modules/networking"

  customer_name      = var.customer_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  create_nat_gateway = var.create_nat_gateway
  tags               = local.common_tags
}

# ============================================================================
# Security Groups Module
# ============================================================================
module "security_groups" {
  source = "../../../modules/security-groups"

  customer_name = var.customer_name
  environment   = var.environment
  vpc_id        = module.networking.vpc_id
  tags          = local.common_tags
}



# ============================================================================
# ACM Certificate
# ============================================================================
resource "aws_acm_certificate" "main" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.customer_name}-${var.environment}-acm-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# ALB Module
# ============================================================================
module "alb" {
  source = "../../../modules/alb"

  customer_name              = var.customer_name
  environment                = var.environment
  vpc_id                     = module.networking.vpc_id
  public_subnet_ids          = module.networking.public_subnet_ids
  alb_security_group_id      = module.security_groups.alb_sg_id
  enable_https               = false # Set to true after ACM validation
  certificate_arn            = aws_acm_certificate.main.arn
  enable_deletion_protection = var.alb_deletion_protection
  tags                       = local.common_tags
}

# ============================================================================
# Frontend Module
# ============================================================================
module "frontend" {
  source = "../../../modules/frontend"

  customer_name        = var.customer_name
  environment          = var.environment
  instance_type        = var.frontend_instance_type
  ami_id               = var.frontend_ami
  key_name             = var.frontend_key_name
  subnet_ids           = module.networking.private_app_subnet_ids
  security_group_id    = module.security_groups.frontend_sg_id
  iam_instance_profile = module.iam.instance_profile_name
  target_group_arn     = module.alb.frontend_target_group_arn
  root_volume_size     = var.frontend_root_volume_size
  tags                 = local.common_tags
}

# ============================================================================
# Backend Module
# ============================================================================
module "backend" {
  source = "../../../modules/backend"

  create_backend_base = var.create_backend_base

  customer_name        = var.customer_name
  environment          = var.environment
  instance_type        = var.backend_instance_type
  ami_id               = var.backend_ami
  key_name             = var.backend_key_name
  subnet_ids           = module.networking.private_app_subnet_ids
  security_group_id    = module.security_groups.backend_sg_id
  iam_instance_profile = module.iam.instance_profile_name
  target_group_arn     = module.alb.backend_target_group_arn
  min_size             = var.backend_min_size
  max_size             = var.backend_max_size
  desired_size         = var.backend_desired_size
  root_volume_size     = var.backend_root_volume_size
  tags                 = local.common_tags
}

# ============================================================================
# RDS Oracle Database
# ============================================================================
module "rds" {
  source = "../../../modules/rds"

  customer_name     = var.customer_name
  environment       = var.environment
  subnet_ids        = module.networking.public_subnet_ids
  security_group_id = module.security_groups.rds_sg_id

  instance_class        = var.rds_instance_class
  engine_version        = var.rds_engine_version
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  database_name   = var.rds_database_name
  master_username = var.rds_master_username
  master_password = var.rds_master_password

  publicly_accessible     = var.rds_publicly_accessible
  multi_az                = var.rds_multi_az
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  maintenance_window      = var.rds_maintenance_window
  monitoring_role_arn     = module.iam.rds_monitoring_role_arn
  deletion_protection     = var.rds_deletion_protection
  skip_final_snapshot     = var.rds_skip_final_snapshot

  tags = local.common_tags
}

# ============================================================================
# Scaling Policies
# ============================================================================
module "scaling" {
  source = "../../../modules/scaling"

  customer_name              = var.customer_name
  environment                = var.environment
  asg_name                   = module.backend.asg_name
  cpu_scale_out_threshold    = var.cpu_scale_out_threshold
  memory_scale_out_threshold = var.memory_scale_out_threshold
  scale_evaluation_periods   = var.scale_evaluation_periods
  scale_cooldown             = var.scale_cooldown
  tags                       = local.common_tags

  depends_on = [module.backend]
}
