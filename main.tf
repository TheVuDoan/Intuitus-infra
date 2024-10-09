provider "aws" {
  profile = "thevudoan"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "intuitus-terraform-state"
    region  = "us-east-1"
    profile = "thevudoan"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

module "vpc" {
  source = "./vpc"
  environment = var.environment
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "rds" {
  source = "./rds"
  environment = var.environment
  public_subnet_ids = module.vpc.public_subnet_ids
  db_security_group_id = module.vpc.db_security_group_id
}

module "opensearch" {
  source = "./opensearch"
  environment = var.environment
  public_subnet_ids = module.vpc.public_subnet_ids
  os_security_group_id = module.vpc.os_security_group_id
}
