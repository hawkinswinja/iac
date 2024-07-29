variable "region" {
  description = "value of the region"
  default     = "eu-west-1"
  type        = string
}

module "vpc" {
  source = "./modules/vpc"
  # region = var.region
}