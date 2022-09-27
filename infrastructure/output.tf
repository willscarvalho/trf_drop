output "ec2_public_ip" {
  value = aws_instance.this[0].public_ip
}