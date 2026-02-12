# AWS Terraform EC2 Infrastructure Platform

Production-ready Terraform infrastructure for deploying scalable web applications on AWS with frontend, backend API, and RDS Oracle database.

## 🏗️ Architecture

```
Internet
    │
    ↓
[Route53 DNS]
    │
    ↓
[Application Load Balancer]
    │
    ├──→ [Frontend EC2] (1 instance)
    │
    └──→ [Backend ASG] (1 base + 0-4 auto-scaled)
              │
              ↓
         [RDS Oracle]
         (Private Subnet, Multi-AZ in prod)
```

## ✨ Features

- **Multi-Environment Support**: Separate prod/dev configurations
- **Auto Scaling**: Backend scales based on CPU/Memory metrics (0-4 instances)
- **High Availability**: Multi-AZ RDS in production, redundant subnets
- **Security**: Private subnets, security groups, encrypted storage
- **Monitoring**: CloudWatch metrics, enhanced RDS monitoring
- **SSM Access**: Secure shell access via AWS Systems Manager
- **Database**: Oracle SE2 with automated backups and performance insights
- **Email Sending**: SES SMTP module for application emails (optional)
- **S3 Storage**: Encrypted S3 bucket for database backups/data (optional)
- **Custom DNS**: Friendly database endpoint names via Route53 (optional)

## 📁 Project Structure

```
terraform-ec2-platform/
├── modules/
│   ├── alb/                 # Application Load Balancer
│   ├── backend/             # Backend EC2 + Auto Scaling Group
│   ├── frontend/            # Frontend EC2 instance
│   ├── iam/                 # IAM roles (EC2, RDS monitoring)
│   ├── networking/          # VPC, subnets, NAT gateway
│   ├── rds/                 # RDS Oracle database
│   ├── s3/                  # S3 bucket for database storage
│   ├── scaling/             # Auto scaling policies
│   ├── security-groups/     # Security groups for all resources
│   └── ses/                 # SES SMTP for email sending
└── environments/
    └── [customer-name]/
        ├── dev/
        │   ├── main.tf
        │   ├── variables.tf
        │   ├── outputs.tf
        │   └── terraform.tfvars    # Dev configuration
        └── prod/
            ├── main.tf
            ├── variables.tf
            ├── outputs.tf
            └── terraform.tfvars    # Prod configuration
```

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0
- AWS CLI configured with credentials
- AWS Account ID (for safety validation)

### 1. Setup Environment

```bash
# Clone or navigate to project
cd terraform-ec2-platform/environments/[customer-name]/dev

# Export AWS credentials
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
# Or use AWS profiles
export AWS_PROFILE="dev-account"
```

### 2. Configure Variables

Edit `terraform.tfvars`:

```hcl
# Environment
customer_name = "your-company"
environment   = "dev"

# Network
vpc_cidr = "172.17.0.0/16"

# Domain
domain_name = "your-domain.com"
backend_domain = "api.your-domain.com"

# RDS Oracle
rds_database_name   = "APPDB"
rds_master_username = "admin"
rds_master_password = "SecurePassword123!"  # CHANGE THIS!
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review changes
terraform plan

# Deploy
terraform apply
```

### 4. Access Resources

After deployment, get important information:

```bash
terraform output
```

**Key Outputs:**
- **ALB DNS**: Use for testing before DNS propagates
- **Route53 Nameservers**: Update at your domain registrar
- **RDS Endpoint**: Database connection string
- **SSH Keys**: Located in `ssh-keys/` directory

## 🔧 Backend Instance Workflow

### Initial Setup (Base Instance)

1. **Deploy with base instance**:
   ```hcl
   create_backend_base = true
   backend_desired_size = 1
   ```

2. **SSH into base instance**:
   ```bash
   ssh -i ssh-keys/[customer]-backend-key.pem ec2-user@[instance-ip]
   ```

3. **Install & configure your application**:
   - Deploy code
   - Configure environment variables
   - Test database connectivity
   - Verify application works

### Switch to Auto Scaling

4. **Create AMI from configured instance**:
   ```bash
   aws ec2 create-image \
     --instance-id i-xxxxx \
     --name "backend-configured-v1"
   ```

5. **Update terraform.tfvars**:
   ```hcl
   backend_ami = "ami-xxxxx"          # Your new AMI
   create_backend_base = false        # Disable base instance
   backend_desired_size = 1           # Enable ASG
   ```

6. **Apply changes**:
   ```bash
   terraform apply
   ```

**Result:**
- Base instance deleted
- ASG creates instance(s) from your configured AMI
- Auto-scaling enabled based on CPU/Memory

## 🗄️ Database Access

### From Backend Instances

```bash
# Connection details
Host: [rds_endpoint from terraform output]
Port: 1521
Database: HCMDB
Username: admin
Password: [from terraform.tfvars]
```

### Security Notes

- RDS is in **private subnet** (not accessible from internet)
- Only backend/frontend instances can connect
- Use **SSH tunnel** for external access:
  ```bash
  ssh -i ssh-keys/backend-key.pem -L 1521:[rds-endpoint]:1521 ec2-user@[backend-ip]
  ```

## 🛡️ Security Features

- ✅ All EBS volumes encrypted
- ✅ RDS encryption at rest
- ✅ Security groups with least privilege
- ✅ IMDSv2 required on EC2
- ✅ Private subnets for database
- ✅ SSM access (no bastion needed)

## 📊 Monitoring

### CloudWatch Metrics

- **EC2**: CPU, Memory, Disk utilization
- **RDS**: Performance insights, enhanced monitoring
- **ALB**: Request count, response time, health checks

### Auto Scaling Triggers

Default thresholds:
- **Scale Out**: CPU > 70% or Memory > 80%
- **Evaluation**: 2 periods of 5 min = 10 minutes
- **Cooldown**: 5 minutes between scaling actions

Adjust in `terraform.tfvars`:
```hcl
cpu_scale_out_threshold    = 70
memory_scale_out_threshold = 80
```

## 🌍 Multi-Customer Setup

### Structure

```
environments/
├── customer-a/
│   ├── prod/    # AWS Account: 111111111111
│   └── dev/     # AWS Account: 222222222222
└── customer-b/
    ├── prod/
    └── dev/
```

### Deploy with Different Accounts

```bash
# Customer A - Production
export AWS_PROFILE=customer-a-prod
cd environments/customer-a/prod
terraform apply

# Customer A - Development
export AWS_PROFILE=customer-a-dev
cd environments/customer-a/dev
terraform apply
```

## ⚙️ Configuration Reference

### Key Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `customer_name` | Customer/company name | Required |
| `environment` | Environment (prod/dev) | Required |
| `vpc_cidr` | VPC CIDR block | `172.17.0.0/16` |
| `rds_instance_class` | RDS instance type | `db.t3.medium` |
| `rds_multi_az` | Enable Multi-AZ | `true` (prod) |
| `backend_max_size` | Max ASG instances | `4` |

### Production vs Development

| Setting | Production | Development |
|---------|-----------|-------------|
| RDS Multi-AZ | `true` | `false` |
| RDS Instance | `db.t3.medium` | `db.t3.small` |
| Deletion Protection | `true` | `false` |

## � Disaster Recovery

### Backup Strategy

- **RDS**: Automated daily backups (7-day retention)
- **Backup Window**: 03:00-04:00 UTC
- **Final Snapshot**: Created on deletion (unless `skip_final_snapshot = true`)

### Restore from Backup

```bash
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier restored-db \
  --db-snapshot-identifier [snapshot-id]
```

## 🧹 Cleanup

```bash
# Destroy all resources
terraform destroy

# Or just specific resources
terraform destroy -target=module.rds
```

## 📝 Common Tasks

### Update Application Code

**Option 1: Create new AMI**
1. Deploy to base instance
2. Test
3. Create AMI
4. Update `backend_ami` in terraform.tfvars
5. Apply

**Option 2: Use user-data** (slower)
- Update `modules/backend/user-data.sh`
- Apply terraform
- Instances will auto-configure on launch

### Scale Backend Manually

```hcl
# terraform.tfvars
backend_desired_size = 3  # Increase to 3 instances
```

```bash
terraform apply
```

### Change Database Password

```bash
aws rds modify-db-instance \
  --db-instance-identifier [db-id] \
  --master-user-password "NewPassword123!"
```

## 🔌 Optional Modules

### SES SMTP Module (Email Sending)

Enable email sending capability for your application using AWS SES.

**Enable in terraform.tfvars:**
```hcl
ses_email_identity = "noreply@yourcompany.com"
# or use domain
ses_email_identity = "yourcompany.com"
```

**Add to main.tf:**
```hcl
module "ses" {
  source         = "../../../modules/ses"
  customer_name  = var.customer_name
  environment    = var.environment
  email_identity = var.ses_email_identity
  aws_region     = var.aws_region
  tags           = local.common_tags
}
```

**Get SMTP credentials:**
```bash
terraform output smtp_username
terraform output smtp_password  # sensitive
terraform output smtp_endpoint
```

**Use cases:**
- Password reset emails
- User notifications
- Registration confirmations
- Automated reports

**Important:** SES starts in sandbox mode. Request production access via AWS Console to send to any email.

---

### S3 Database Storage Module

Create encrypted S3 bucket for database backups, exports, and data storage.

**Add to main.tf:**
```hcl
module "s3_database" {
  source = "../../../modules/s3"
  
  bucket_name             = "${var.customer_name}-${var.environment}-db-storage"
  enable_versioning       = true
  lifecycle_days          = 90
  backup_retention_days   = 30
  vpc_id                  = module.networking.vpc_id
  route_table_ids         = module.networking.private_route_table_ids
  create_vpc_endpoint     = true  # For private S3 access
  allowed_role_arns       = [module.iam.instance_role_arn]
  aws_region              = var.aws_region
  tags                    = local.common_tags
}

# Update IAM module to grant access
module "iam" {
  source        = "../../../modules/iam"
  customer_name = var.customer_name
  environment   = var.environment
  s3_bucket_arn = module.s3_database.bucket_arn  # Add this line
  tags          = local.common_tags
}
```

**Features:**
- ✅ AES256 encryption
- ✅ Versioning (90-day retention)
- ✅ Lifecycle policies
- ✅ Private access via VPC endpoint (no NAT charges)
- ✅ Automatic EC2 permissions

**Use from EC2:**
```bash
aws s3 ls s3://[customer]-[env]-db-storage/
aws s3 cp backup.sql s3://[customer]-[env]-db-storage/backups/
```

---

### Custom RDS Endpoint (Friendly DNS)

Create a short, memorable DNS name for your database instead of long RDS endpoint.

**Enable in terraform.tfvars:**
```hcl
create_custom_db_endpoint = true
```

**Add to main.tf (after RDS module):**
```hcl
resource "aws_route53_record" "db_custom_endpoint" {
  count   = var.create_custom_db_endpoint ? 1 : 0
  zone_id = local.hosted_zone_id
  name    = "db.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [module.rds.endpoint]
}
```

**Result:**
- Instead of: `demo-oracle.abc123.ap-southeast-1.rds.amazonaws.com:1521`
- Use: `db.yourcompany.com:1521`

**Benefits:**
- Easier to remember
- Can change RDS instance without code changes
- Consistent across environments

---

## ⚠️ Important Notes

1. **DNS Setup**: You must manually update nameservers at your domain registrar after first deployment
2. **RDS Password**: Change the default password in production
3. **Account ID**: Set `expected_account_id` to prevent deploying to wrong account
4. **Cost**: Running infrastructure incurs AWS costs (RDS, EC2, NAT Gateway)

## 🆘 Troubleshooting

### Issue: Terraform init fails with "module not found"

**Solution**: Check module paths in `main.tf`:
```hcl
# For structure: environments/customer/env/
source = "../../../modules/[module-name]"

# For structure: environments/env/
source = "../../modules/[module-name]"
```

### Issue: Cannot SSH to instances

**Solution**: Use SSM Session Manager instead:
```bash
aws ssm start-session --target i-xxxxx
```

### Issue: RDS connection timeout

**Checklist:**
- ✓ Security group allows backend SG on port 1521
- ✓ RDS is in private subnet
- ✓ Backend instance can reach RDS subnet
- ✓ Connection string is correct

## 📚 Additional Resources

- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [RDS Oracle Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Oracle.html)
- [Auto Scaling Guide](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)

## � License

This infrastructure code is provided as-is for internal use.

---

**Need Help?** Review the deployment walkthrough in the artifacts directory or check Terraform outputs for next steps.
