
provider "aws" {
  region  = var.aws_region
  profile = "default"
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.env, terraform.workspace)}:role/Role_For-S3_Creation"
  }
  default_tags {
    tags = module.required_tags.aws_default_tags
  }
}

terraform {
  required_version = ">=1.1.5"

  backend "s3" {
    bucket = "ecs.working.cluster.terraform"
    key    = "path/env"
    region = "us-east-1"
  }
}
