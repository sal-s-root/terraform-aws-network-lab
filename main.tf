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
  cidr_block           = "10.42.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.42.1.0/24"
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
