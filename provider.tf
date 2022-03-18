provider "aws" {
profile = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "tf-project-omega"
    key            = "haplet.tfstate"
    encrypt = true
    region         = "us-west-2"

  }
}
