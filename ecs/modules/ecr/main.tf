variable "name_prefix" {
  type = string
}

resource "aws_ecr_repository" "web" {
  name                 = "ecr-${var.name_prefix}-web-1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "ecr-${var.name_prefix}-web-1"
  }
}

resource "aws_ecr_repository" "debug" {
  name                 = "ecr-${var.name_prefix}-debug-1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "ecr-${var.name_prefix}-debug-1"
  }
}

output "web_repository_url" {
  value = aws_ecr_repository.web.repository_url
}

output "debug_repository_url" {
  value = aws_ecr_repository.debug.repository_url
}
