variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "local"
  vpc  = var.vpc_id

  tags = {
    Name = "sdns-${var.name_prefix}-1"
  }
}

resource "aws_service_discovery_service" "web" {
  name = "web"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }


  tags = {
    Name = "sd-web-${var.name_prefix}-1"
  }
}

resource "aws_service_discovery_service" "debug" {
  name = "debug"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  # health_check_custom_config {
  #   failure_threshold = 1
  # }

  tags = {
    Name = "sd-debug-${var.name_prefix}-1"
  }
}

output "namespace_id" {
  value = aws_service_discovery_private_dns_namespace.main.id
}

output "namespace_name" {
  value = aws_service_discovery_private_dns_namespace.main.name
}

output "web_service_arn" {
  value = aws_service_discovery_service.web.arn
}

output "debug_service_arn" {
  value = aws_service_discovery_service.debug.arn
}
