terraform {
  required_version = ">= 1.7, < 2.0"
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
    tags = var.tags
  }
}

module "network" {
  source          = "./modules/network"
  name            = var.name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  tags            = var.tags
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "isolated_security_group_id" {
  value = module.network.isolated_security_group_id
}
