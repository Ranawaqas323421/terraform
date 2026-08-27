# ---------- Provider ----------
provider "aws" {
  region = "us-east-1"
}

# ---------- Step 1: SSH Key Pair ----------
resource "aws_key_pair" "waqas323" {
  key_name   = "waqas323"
  public_key = file("/home/ubuntu/terraform-ec2/waqas323.pub")
}

# ---------- Default VPC ----------
data "aws_vpc" "default" {
  default = true
}

# ---------- Security Group ----------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

# ---------- EC2 Instance ----------
resource "aws_instance" "web_server" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.waqas323.key_name
  subnet_id              = "subnet-005d4953d9734f867"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size           = 18
    volume_type            = "gp3"
    delete_on_termination  = true
  }

  tags = {
    Name = "web_server"
  }
}

# ---------- Output ----------
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
