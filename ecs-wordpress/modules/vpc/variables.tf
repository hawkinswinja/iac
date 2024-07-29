variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    default = "10.0.0.0/16"  
}

variable "subnet_cidr" {
    description = "CIDR block for the subnet"
    default = ["10.0.1.0/24", "10.0.2.0/24"]  
}

variable "vpc_name" {
    description = "Tag Name for the vpc"
    default = "ecs-project1"
    type = string
}