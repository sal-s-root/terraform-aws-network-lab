terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "name" { type = string }
variable "vpc_cidr" { type = string }
variable "private_subnets" {
  type = map(object({ cidr = string, az = string }))
}
variable "tags" { type = map(string) }

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = var.name })
}

resource "aws_subnet" "private" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "${var.name}-private-${each.key}" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-private" })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "isolated" {
  name_prefix = "${var.name}-isolated-"
  description = "No ingress or egress rules; attach explicit reviewed rules before use"
  vpc_id      = aws_vpc.this.id
  ingress     = []
  egress      = []
  tags        = var.tags
}

output "vpc_id" { value = aws_vpc.this.id }
output "private_subnet_ids" { value = { for key, subnet in aws_subnet.private : key => subnet.id } }
output "isolated_security_group_id" { value = aws_security_group.isolated.id }
output "subnet_count" { value = length(aws_subnet.private) }
output "public_ip_assignment" { value = [for subnet in aws_subnet.private : subnet.map_public_ip_on_launch] }
output "egress_rule_count" { value = length(aws_security_group.isolated.egress) }
