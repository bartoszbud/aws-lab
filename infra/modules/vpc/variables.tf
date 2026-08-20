variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cidr_block" {
  description = "VPC IP address"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Incorrect value, CIDR has to be in correct format, e.g., 10.0.0.0/16"
  }
}

variable "public_subnets" {
  description = "value"
  type = map(object({
    cidr              = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "value"
  type = map(object({
    cidr              = string
    availability_zone = string
  }))
}