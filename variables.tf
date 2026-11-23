variable "name" {
  type        = string
  description = "Prefix for named lab resources"
  default     = "infra-lab"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,24}$", var.name))
    error_message = "Use 3-25 lowercase letters, numbers, and hyphens, starting with a letter."
  }
}

variable "region" {
  type        = string
  description = "AWS region matching the explicitly selected availability zones"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 VPC CIDR with a provider-supported prefix length"
  default     = "10.42.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && try(tonumber(split("/", var.vpc_cidr)[1]) >= 16 && tonumber(split("/", var.vpc_cidr)[1]) <= 28, false)
    error_message = "Use a valid IPv4 CIDR with a prefix length from 16 to 28."
  }
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "At least two private subnet definitions in distinct availability zones"
  default = {
    a = { cidr = "10.42.1.0/24", az = "us-east-1a" }
    b = { cidr = "10.42.2.0/24", az = "us-east-1b" }
  }
  validation {
    condition     = length(var.private_subnets) >= 2 && length(distinct([for subnet in values(var.private_subnets) : subnet.az])) >= 2 && alltrue([for subnet in values(var.private_subnets) : can(cidrnetmask(subnet.cidr))])
    error_message = "Supply valid IPv4 subnet CIDRs across at least two availability zones."
  }
}

variable "tags" {
  type        = map(string)
  description = "Ownership and environment tags"
  default = {
    Project     = "infrastructure-network-lab"
    Environment = "lab"
    Owner       = "platform"
  }
}
