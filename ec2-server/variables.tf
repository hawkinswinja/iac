variable "region" {
  type = string
  description = "region to create the resources"
  default = "us-east-1"
}

variable "vpc-name" {
  type = string
  description = "Name of the vpc to create"
}

variable "vpc-cidr" {
  type = string
  description = "cidr block for the vpc"
  default = "10.10.0.0/16"
}

variable "subnet-cidr" {
  type = string
  description = "cidr block for subnets"
  default = "10.10.1.0/24"
}

variable "instance-type" {
  type = string
  description = "ec2 instance type"
  default = "t2.micro"
}

variable "key-name" {
  type = string
  description = "ssh key to access ec2"
  default = "aws101"
}
