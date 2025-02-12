provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source             = "../../modules/networking"
  vpc_name           = var.vpc_name
  cidr               = var.cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
}

module "bastion" {
  source            = "../../modules/Bastion"
  vpc_id            = module.vpc.vpc_id
  public_subnets_ids = module.vpc.public_subnets_ids  
}