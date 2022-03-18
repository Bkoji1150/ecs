
data "aws_route53_zone" "mydomain" {
  name = "kojitechs.com"
}

data "aws_caller_identity" "current" {}
