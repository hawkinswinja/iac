resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance-type
  associate_public_ip_address = true
  key_name = var.key-name
  subnet_id = aws_subnet.main.id
  
  tags = {
    Name = "main"
  }
}

resource "aws_eip" "bar" {
  domain = "vpc"
  instance                  = aws_instance.main.id
  depends_on                = [aws_internet_gateway.gw]
}

data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
