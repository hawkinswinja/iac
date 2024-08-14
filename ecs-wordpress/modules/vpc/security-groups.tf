# Security Group configuration

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow inbound traffic on port 80 and 22, and outbound traffic on port 3306"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow inbound traffic from public_sg on port 22 and outbound traffic to private_sg on port 3306"

  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "private_sg" {
  value = aws_security_group.private_sg.id
}