terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = "infrastructure-lab"
      Purpose = "learning"
    }
  }
}

resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lab.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "isolated" {
  name_prefix = "infra-lab-isolated-"
  description = "Lab group without ingress or egress rules"
  vpc_id      = aws_vpc.lab.id
  ingress     = []
  egress      = []
}

variable "region" {
  description = "AWS region for an explicitly reviewed lab deployment"
  type        = string
  default     = "us-east-1"
}

output "vpc_id" {
  value = aws_vpc.lab.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the isolated lab VPC"
  type        = string
  default     = "10.42.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "subnet_cidr" {
  description = "IPv4 subnet CIDR; review containment in vpc_cidr before applying"
  type        = string
  default     = "10.42.1.0/24"
  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "subnet_cidr must be a valid IPv4 CIDR."
  }
}

output "isolated_security_group_id" {
  value = aws_security_group.isolated.id
}
