data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon"]
}
resource "aws_launch_template" "main" {
  name_prefix            = "ecs-launch-template"
  image_id               = data.aws_ami.amazon_linux_ecs.id
  instance_type          = var.ecs_instance_type
  vpc_security_group_ids = var.ecs_security_groups
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  monitoring {
    enabled = true
  }
  user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
EOF
  )
}

resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = var.ecs_subnets
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-ecs-asg"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "main" {
  name = "${var.name}-ecs-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name = var.name
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }
}

# ECR repository

resource "aws_ecr_repository" "repo" {
  name                 = var.repo-name
  image_tag_mutability = "MUTABLE"
  force_delete         = "true"

  image_scanning_configuration {
    scan_on_push = true
  }
}

