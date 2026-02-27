
locals {
  name_prefix = "${var.org}-${var.unit}-${var.environment}-${var.region}"
}

module "vpc" {
  source             = "./modules/vpc"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  aws_region         = var.aws_region
}

module "security_groups" {
  source      = "./modules/security-groups"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
}

module "ecr" {
  source      = "./modules/ecr"
  name_prefix = local.name_prefix
}

module "service_discovery" {
  source      = "./modules/service-discovery"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

module "ecs" {
  source                    = "./modules/ecs"
  name_prefix               = local.name_prefix
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  web_security_group_id     = module.security_groups.web_sg_id
  debug_security_group_id   = module.security_groups.debug_sg_id
  web_ecr_repository_url    = module.ecr.web_repository_url
  debug_ecr_repository_url  = module.ecr.debug_repository_url
  service_discovery_namespace_id = module.service_discovery.namespace_id
  web_service_discovery_arn = module.service_discovery.web_service_arn
  debug_service_discovery_arn = module.service_discovery.debug_service_arn
  aws_region                = var.aws_region
}
