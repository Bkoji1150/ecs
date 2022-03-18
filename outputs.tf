# outputs you can kist required endpoints, ip or instanceid's
output "flask_app_dns" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value = aws_route53_record.default_dns.name
}