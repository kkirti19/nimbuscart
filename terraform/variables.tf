variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "nimbuscart"
}

variable "web_vpc_cidr" {
  description = "CIDR for web VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "data_vpc_cidr" {
  description = "CIDR for data VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "web_subnet_cidr" {
  description = "Public web subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "app_subnet_cidr" {
  description = "Application subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "db_subnet_a_cidr" {
  description = "Database subnet A"
  type        = string
  default     = "10.20.2.0/24"
}

variable "db_subnet_b_cidr" {
  description = "Database subnet B"
  type        = string
  default     = "10.20.3.0/24"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "nimbusadmin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
