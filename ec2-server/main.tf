module "server-main" {
  source = "./main"
  vpc-name = "dev"
  ami    = "ami-0c7217cdde317cfec"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
