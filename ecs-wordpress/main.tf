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
  efs_security_group_ids = [module.vpc.efs_sg]
  log_region = var.region
}

output "ecr_repo_url" {
  value = module.ecs.ecr_repo_url
}