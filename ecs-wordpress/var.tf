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

variable "repo-name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "db_name" {
  description = "name of the database"
  type        = string
}
