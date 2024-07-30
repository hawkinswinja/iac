variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_name" {
  description = "Tag Name for the vpc"
  default     = "ecs-project1"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

# variable "db_host" {
#     description = "Host for the database"
#     type = string  
# }

variable "db_name" {
  description = "Name for the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key id for the SSM parameter"
  type        = string
  sensitive   = true
}