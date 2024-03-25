######################## General Values ########################
variable "region" {
  description = "AWS Region"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "app_name" {
  description = "Application Name"
  type        = string
}

######################## ECR Values ############################
variable "create_ecr" {
  description = "ECR control creation"
  type        = bool
}

variable "ecr" {
  description = "ECR Configuration"
  type        = any
}

######################## VPC Values ############################
variable "create_vpc" {
  description = "VPC control creation"
  type        = bool
}

variable "vpc" {
  description = "VPC Configuration"
  type        = any
}

######################## ECS Values ###########################
variable "create_ecs" {
  description = "ECS control creation"
  type        = bool
}

variable "ecs" {
  description = "ECS Configuration"
  type        = any
}
