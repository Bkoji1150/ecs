
data "aws_route53_zone" "mydomain" {
  name = lookup(var.dns_name, terraform.workspace)
}

data "aws_caller_identity" "current" {}
