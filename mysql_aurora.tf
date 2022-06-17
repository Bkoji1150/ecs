
resource "aws_kms_key" "encryption_key" {
  description         = "Sonar Encryption Key"
  is_enabled          = true
  enable_key_rotation = true

  tags = merge({
    Name = "${var.name_prefix}-sonar-kms-key"
  }, var.tags)
}

module "aurora" {
  source = "git::https://github.com/Bkoji1150/aws-rdscluster-kojitechs-tf.git"

  name           = var.name_prefix
  engine         = "aurora-postgresql"
  engine_version = "11.12"
  instances = {
    1 = {
      instance_class      = "db.r5.large"
      publicly_accessible = false
    }
    2 = {
      identifier     = format("%s-%s", "kojitechs-${var.name_prefix}", "reader-instance")
      instance_class = "db.r5.xlarge"
      promotion_tier = 15
    }
  }
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = [aws_security_group.Project-Omega_sg["rds"].id]
  create_db_subnet_group = true
  create_security_group  = false
  subnets                = local.database_subnet

  iam_database_authentication_enabled = true
  create_random_password              = false
  kms_key_id                          = aws_kms_key.encryption_key.arn
  apply_immediately                   = true
  skip_final_snapshot                 = true

  db_parameter_group_name         = aws_db_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["postgresql"]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id

}

resource "aws_db_parameter_group" "example" {
  name        = "${var.name_prefix}-aurora-db-57-parameter-group"
  family      = "aurora-postgresql11"
  description = "${var.name_prefix}-aurora-db-57-parameter-group"

}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${var.name_prefix}-aurora-57-cluster-parameter-group"
  family      = "aurora-postgresql11"
  description = "${var.name_prefix}-aurora-57-cluster-parameter-group"

}
