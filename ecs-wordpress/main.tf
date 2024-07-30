variable "region" {
  description = "value of the region"
  default     = "eu-west-1"
  type        = string
}

variable "vpc_name" {
  description = "name of the VPC"
  type        = string
}

variable "db_password" {
  description = "password for the database"
  type        = string
}

variable "db_username" {
  description = "username for the database"
  type        = string
}

variable "kms_key_id" {
  description = "ID of the KMS key"
  type        = string
}

variable "db_name" {
  description = "name of the database"
  type        = string
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  db_password = var.db_password
  db_username = var.db_username
  kms_key_id  = var.kms_key_id
  db_name     = var.db_name
}
output "db_cluster_endpoint" {
  value = module.vpc.db_cluster_endpoint
}

# output "db_address" {
#   value = module.vpc.db_address

# }