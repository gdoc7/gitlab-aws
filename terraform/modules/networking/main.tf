data "aws_availability_zones" "available" {
  state = "available"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name            = var.vpc_name
  cidr            = var.cidr
  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  create_database_subnet_group           = false
  create_database_subnet_route_table     = false
  create_database_internet_gateway_route = false

  enable_dns_hostnames = true
  enable_dns_support   = true


  public_subnet_tags = {
    Name = "gitlab-public"
  }

  private_subnet_tags = {
    Name = "gitlab-private" 
  }

  map_public_ip_on_launch = true
}

