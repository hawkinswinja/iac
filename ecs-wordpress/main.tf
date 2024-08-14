module "vpc" {
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
}

# module "rds" {
#   source      = "./modules/rds"
#   db_password = var.db_password
#   db_username = var.db_username
#   db_name     = var.db_name
#   kms_key_id  = var.kms_key_id
#   rds-security-group = module.vpc.private_sg
#   db_subnets  = module.vpc.aws_subnet.ecs-private-subnet[*].id
#   name        = var.vpc_name
# }

module "ecs" {
  source      = "./modules/ecs"
  name        = var.vpc_name
  repo-name   = var.repo-name
  ecs_subnets = module.vpc.ecs-private-subnet
  ecs_security_groups = [module.vpc.private_sg]
}

# output "db_cluster_endpoint" {
#   value = module.vpc.db_cluster_endpoint
# }

# output "db_address" {
#   value = module.vpc.db_address

# }