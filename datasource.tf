

data "aws_elb_service_account" "main" {}

data "aws_secretsmanager_secret_version" "rds_secret_target" {
  depends_on = [module.aurora]
  secret_id  = module.aurora.secrets_version
}
