# ECS TASK DEFINITION
# resource "aws_ecs_task_definition" "task1" {
#   family             = "${var.name}-task"
#   task_role_arn      = aws_iam_role.ecs_task_role.arn
#   execution_role_arn = aws_iam_role.ecs_exec_role.arn
#   network_mode       = "awsvpc"
#   cpu                = 256
#   memory             = 256

#   container_definitions = jsonencode([{
#     name         = "${var.name}-container",
#     image        = "${aws_ecr_repository.app.repository_url}:${var.tag}",
#     essential    = true,
#     portMappings = [{ containerPort = var.container_port }],

#     logConfiguration = {
#       logDriver = "awslogs",
#       options = {
#         "awslogs-region"        = "${var.log_region}",
#         "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
#         "awslogs-stream-prefix" = "${var.name}-container-logs"
#       }
#     },
#   }])


#   volume {
#     name = "${var.name}-efs-volume"

#     efs_volume_configuration {
#       file_system_id          = aws_efs_file_system.fs.id
#       root_directory          = "/opt/data"
#       transit_encryption      = "ENABLED"
#       transit_encryption_port = 2999
#       authorization_config {
#         access_point_id = aws_efs_access_point.test.id
#         iam             = "ENABLED"
#       }
#     }
#   }
# }

# efs for task definition
resource "aws_efs_file_system" "fs" {
  creation_token = "${var.name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true
#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
  tags = {
    Name = "${var.name}-efs"
  }
}

# efs access point for task definition
resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.fs.id
  root_directory {
    path = "/opt/data"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "755"
    }
  }
}

#efs mount target for task definition
resource "aws_efs_mount_target" "efs_mount_target" {
  count = length(var.ecs_subnets)
  file_system_id = aws_efs_file_system.fs.id
  subnet_id = var.ecs_subnets[count.index]
  security_groups = var.ecs_security_groups
}
# ECS SERVICE
# resource "aws_ecs_service" "service1" {
#   name            = "${var.name}-service"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.task1.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = var.ecs_subnets
#     security_groups  = var.ecs_security_groups
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.tg.arn
#     container_name   = "${var.name}-container"
#     container_port   = var.container_port
#   }

#   depends_on = [aws_lb_listener.listener]
# }