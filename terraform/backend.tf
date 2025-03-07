terraform {
  backend "s3" {
    bucket = "gl-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}