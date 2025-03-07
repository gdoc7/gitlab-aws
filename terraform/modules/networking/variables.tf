# Environment Variable

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

# VPC CIDR Block
variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
}

# VPC Public Subnets
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

# VPC Private Subnets
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}


variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}
