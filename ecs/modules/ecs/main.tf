variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "web_security_group_id" {
  type = string
}

variable "debug_security_group_id" {
  type = string
}

variable "web_ecr_repository_url" {
  type = string
}

variable "debug_ecr_repository_url" {
  type = string
}

variable "service_discovery_namespace_id" {
  type = string
}

variable "web_service_discovery_arn" {
  type = string
}

variable "debug_service_discovery_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

resource "aws_ecs_cluster" "main" {
  name = "ecs-${var.name_prefix}-1"

  tags = {
    Name = "ecs-${var.name_prefix}-1"
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "iamrole-ecsexec-${var.name_prefix}-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "iamrole-ecsexec-${var.name_prefix}-1"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/web-${var.name_prefix}"
  retention_in_days = 7

  tags = {
    Name = "cwlg-web-${var.name_prefix}-1"
  }
}

resource "aws_cloudwatch_log_group" "debug" {
  name              = "/ecs/debug-${var.name_prefix}"
  retention_in_days = 7

  tags = {
    Name = "cwlg-debug-${var.name_prefix}-1"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "td-web-${var.name_prefix}-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "web"
    image = "${var.web_ecr_repository_url}:latest"
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.web.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "web"
      }
    }
  }])

  tags = {
    Name = "td-web-${var.name_prefix}-1"
  }
}

resource "aws_ecs_task_definition" "debug" {
  family                   = "td-debug-${var.name_prefix}-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name    = "debug"
    image   = "${var.debug_ecr_repository_url}:latest"
    command = ["/bin/sh", "-c", "while true; do nslookup web.local || true; sleep 10; done"]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.debug.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "debug"
      }
    }
  }])

  tags = {
    Name = "td-debug-${var.name_prefix}-1"
  }
}

resource "aws_ecs_service" "web" {
  name            = "ecssvc-web-${var.name_prefix}-1"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.web_security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = var.web_service_discovery_arn
  }

  tags = {
    Name = "ecssvc-web-${var.name_prefix}-1"
  }
}

resource "aws_ecs_service" "debug" {
  name            = "ecssvc-debug-${var.name_prefix}-1"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.debug.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.debug_security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = var.debug_service_discovery_arn
  }

  tags = {
    Name = "ecssvc-debug-${var.name_prefix}-1"
  }
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "web_service_name" {
  value = aws_ecs_service.web.name
}

output "debug_service_name" {
  value = aws_ecs_service.debug.name
}
