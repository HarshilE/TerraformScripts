resource "aws_security_group" "aws_sg" {
  name = "public-web-sg"

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aws_ins" {
  ami                         = "ami-0f58b397bc5c1f2e8"  # Ubuntu AMI ID
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.aws_sg.id]  # Attach the security group to the instance
  associate_public_ip_address = true
  key_name                    = "c2s-key"  # Replace with your key pair name

  tags = {
    Name = "My-instance"
  }
}

output "instance_ip" {
  value = aws_instance.aws_ins.public_ip
}
