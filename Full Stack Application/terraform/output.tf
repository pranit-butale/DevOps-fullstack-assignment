# Outputs
output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}