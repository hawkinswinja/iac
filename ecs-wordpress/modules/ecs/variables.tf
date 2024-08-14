
variable "repo-name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "name" {
  description = "Name for the ECS cluster"
  type        = string
}

variable "ecs_subnets" {
  description = "Subnet IDs for the ECS cluster. Preferably private subnets."
  type        = list(string)
}

variable "ecs_instance_type" {
  description = "Instance type for the ECS cluster"
  type        = string
  default     = "t2.micro"
}
variable "ecs_security_groups" {
  description = "Security group IDs for the ECS cluster"
  type        = list(string)
}