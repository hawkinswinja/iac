variable "region" {
  description = "value of the region"
  default     = "us-east-1"
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

variable "repo-name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "db_name" {
  description = "name of the database"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
  
}

variable "ecs_instance_type" {
  description = "Instance type for the ECS cluster"
  type        = string
  default     = "t2.micro"
}

variable "tag" {
  description = "Tag for the ECR repository"
  type        = string
  default     = "latest"
}

variable "certificate_arn" {
  description = "ARN of the SSL/TLS certificate"
  type        = string
}

variable "image_tag" {
  description = "Tag for the ECR repository"
  type        = string
  default     = "latest"
}