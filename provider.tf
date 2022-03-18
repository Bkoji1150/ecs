provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = local.default_tags
  }
}
