output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of subnet publics"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of subnet privates"
  value       = module.vpc.private_subnets
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "vpc_owner_id" {
  value = module.vpc.vpc_owner_id
}