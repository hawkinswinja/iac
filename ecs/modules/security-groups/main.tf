variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

resource "aws_security_group" "web" {
  name        = "nsg-web-${var.name_prefix}-1"
  description = "Security group for web service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # for more airtight env that don't want to allow all outbound traffic comment out the rule above, and limit egress to vpc-cidr and prefix-lists instead. 
  # s3 gateway is required to pull down container images from ECR, add this rule to all ecs task security groups. 
  # If you have other outbound traffic requirements, you can add more egress rules here.

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = [var.vpc_cidr]
  # }

  # egress {
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   prefix_list_ids = [data.aws_prefix_list.s3.id] 
  # }

  tags = {
    Name = "nsg-web-${var.name_prefix}-1"
  }
}

resource "aws_security_group" "debug" {
  name        = "nsg-debug-${var.name_prefix}-1"
  description = "Security group for debug service"
  vpc_id      = var.vpc_id

  # debug conatiner used to test connection to web container, does not need ingress rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nsg-debug-${var.name_prefix}-1"
  }
}

output "web_sg_id" {
  value = aws_security_group.web.id
}

output "debug_sg_id" {
  value = aws_security_group.debug.id
}
