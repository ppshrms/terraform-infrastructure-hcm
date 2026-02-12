output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.standalone_ec2.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.standalone_ec2.public_ip
}

output "ec2_private_ip" {
  description = "EC2 private IP address"
  value       = aws_instance.standalone_ec2.private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "ssh_command" {
  description = "SSH command to connect (if you have the key)"
  value       = "ssh -i your-key.pem ec2-user@${aws_instance.standalone_ec2.public_ip}"
}

output "ssm_command" {
  description = "AWS Systems Manager command to connect"
  value       = "aws ssm start-session --target ${aws_instance.standalone_ec2.id}"
}
