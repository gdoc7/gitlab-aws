variable "vpc_name" {
  description = "VPC Name"
  type        = string
}
variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}
