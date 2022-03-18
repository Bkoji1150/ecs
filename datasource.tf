
data "aws_route53_zone" "mydomain" {
  name = "kojitechs.com"
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  version = "3.0.0"

  domain_name = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id     = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = [
    "*.kojitechs.com"
  ]

}
