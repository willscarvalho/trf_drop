data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${local.prefix}-key"
  public_key = var.aws_public_key
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.aws_instance_type
  count                       = 1
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.sg-web.id]
  subnet_id              = aws_subnet.this.id
  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-site"
    }
  )
}