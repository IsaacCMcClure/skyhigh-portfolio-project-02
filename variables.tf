variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "skyhigh-project-02"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones used by the VPC"
  type        = list(string)
}

variable "my_ip" {
  description = "Public IP address allowed to SSH into the web server"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}
