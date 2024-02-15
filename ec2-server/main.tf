module "server-main" {
  source = "./main"
  vpc-name = var.vpc-name
  ami    = "ami-0c7217cdde317cfec"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc-name" {
  type = string
}

output "instance_ip" {
  value = module.server-main.eip-public-ip
}
