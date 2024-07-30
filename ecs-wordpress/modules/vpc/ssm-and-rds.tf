# Create SSM encrypted data for wordpress environment

resource "aws_ssm_parameter" "ssm-key" {
  for_each = tomap({
    # "/wordpress/WORDPRESS_DB_HOST"     = aws_db_instance.db.address
    "/wordpress/WORDPRESS_DB_HOST"     = aws_rds_cluster.aurora.endpoint
    "/wordpress/WORDPRESS_DB_USER"     = var.db_username
    "/wordpress/WORDPRESS_DB_PASSWORD" = var.db_password
    "/wordpress/WORDPRESS_DB_NAME"     = var.db_name
  })

  name   = each.key
  type   = "SecureString"
  value  = each.value
  key_id = var.kms_key_id

}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"  # Example of a supported version
  master_username         = var.db_username
  master_password         = var.db_password
  database_name           = var.db_name
  kms_key_id              = var.kms_key_id
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [aws_security_group.private_sg.id]
  storage_encrypted       = true
  skip_final_snapshot     = true

  # scaling_configuration {
  #   auto_pause               = true
  #   max_capacity             = 2
  #   min_capacity             = 1
  #   seconds_until_auto_pause = 300
  # }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t3.micro"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.db.name
}

# resource "aws_db_instance" "db" {
#   allocated_storage       = 20
#   storage_type            = "gp2"
#   engine                  = "aurora-mysql"
#   engine_version          = "5.7"
#   instance_class          = "db.t3.micro"
#   db_name                 = var.db_name
#   username                = var.db_username
#   password                = var.db_password
#   kms_key_id              = var.kms_key_id
#   skip_final_snapshot     = true
#   publicly_accessible     = false
#   multi_az                = false
#   storage_encrypted       = true
#   vpc_security_group_ids  = [aws_security_group.private_sg.id]
#   db_subnet_group_name    = aws_db_subnet_group.db.name
#   backup_retention_period = 1
#   availability_zone       = data.aws_subnet.first_private_subnet.availability_zone

#   tags = {
#     Name    = "${var.vpc_name}-db"
#     Project = "${var.vpc_name}-db"
#   }
# }

resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.ecs-subnet[*].id
}

output "db_cluster_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

# output "db_address" {
#   value = aws_db_instance.db.address
# }

# data "aws_subnet" "first_private_subnet" {
#   id = local.private_subnet_associations[0].subnet_id
# }