

data "terraform_remote_state" "operational_environment" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "operational.vpc.tf.kojitechs"
    key    = format("env:/%s/path/env", lower(terraform.workspace))
  }
}


locals {
  operational_state    = data.terraform_remote_state.operational_environment.outputs
  vpc_id               = local.operational_state.vpc_id
  public_subnet        = local.operational_state.public_subnets
  private_subnets      = local.operational_state.private_subnets
  private_sunbet_cidrs = local.operational_state.private_subnets_cidrs
  database_subnet      = local.operational_state.database_subnets
  mysql                = data.aws_secretsmanager_secret_version.rds_secret_target
  name                 = "kojitechs-${replace(basename(var.name_prefix), "-", "-")}"

  security_groups = {
    lb = {
      name        = "lb_sg"
      description = "Allow http and ssh inbound traffic"
      ingress = {
        sonar = {
          from        = 9000
          to          = 9000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    rds = {
      name        = "rds_sg"
      description = "rds access"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          # security_group_id = [aws_security_group.Project-Omega_sg["ecs_sg"].id]
        }
      }
    }
    ecs_sg = {
      name        = "ecs_sg"
      description = "rds access"
      ingress = {
        mysql = {
          from        = 9000
          to          = 9000
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          # security_group_id = [aws_security_group.Project-Omega_sg["lb"].id]
        }
      }
    }
  }
}


resource "aws_security_group" "Project-Omega_sg" {
  for_each    = local.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = local.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      #description      =
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

output "db_security_group" {
  value = [aws_security_group.Project-Omega_sg["rds"].id] # Just are specific RDS instance
}

#------------------------------------------------------------------------------
# AWS Cloudwatch Logs
#------------------------------------------------------------------------------

# module "microservice" {
#   source = "./ecs-farget"

#   name_prefix                  = "${var.name_prefix}-sonar"
#   vpc_id                       = local.vpc_id
#   public_subnets_ids           = local.public_subnet
#   private_subnets_ids          = local.private_subnets
#   container_name               = "${var.name_prefix}-sonar"
#   container_image              = var.sonarqube_image
#   container_cpu                = 4096
#   container_memory             = 8192
#   container_memory_reservation = 4096
#   enable_autoscaling           = var.enable_autoscaling
#   ephemeral_storage_size       = var.ephemeral_storage_size
#   # lb_security_groups           = [aws_security_group.Project-Omega_sg["lb"].id]
#   # ecs_service_security_groups  = [aws_security_group.Project-Omega_sg["ecs_sg"].id]

#   dns_name  = var.dns_name
#   subject_alternative_names = var.subject_alternative_names

#   lb_http_ports                       = var.lb_http_ports
#   lb_https_ports                      = var.lb_https_ports
#   lb_enable_cross_zone_load_balancing = var.lb_enable_cross_zone_load_balancing
#   # default_certificate_arn             = var.enable_ssl ? module.acm.acm_certificate_arn : null


#   enable_s3_logs                                 = var.enable_s3_logs
#   block_s3_bucket_public_access                  = var.block_s3_bucket_public_access
#   enable_s3_bucket_server_side_encryption        = var.enable_s3_bucket_server_side_encryption
#   s3_bucket_server_side_encryption_sse_algorithm = var.s3_bucket_server_side_encryption_sse_algorithm
#   s3_bucket_server_side_encryption_key           = var.s3_bucket_server_side_encryption_key

#   command = [
#     "-Dsonar.search.javaAdditionalOpts=-Dnode.store.allow_mmap=false"
#   ]
#   ulimits = [
#     {
#       "name" : "nofile",
#       "softLimit" : 65535,
#       "hardLimit" : 65535
#     }
#   ]
#   port_mappings = [
#     {
#       containerPort = 9000
#       hostPort      = 9000
#       protocol      = "tcp"
#     }
#   ]
#   environment = [
#     {
#       name  = "SONAR_JDBC_USERNAME"
#       value = jsondecode(local.mysql.secret_string)["username"]
#     },
#     {
#       name  = "SONAR_JDBC_PASSWORD"
#       value = jsondecode(local.mysql.secret_string)["password"]
#     },
#     {
#       name  = "SONAR_JDBC_URL"
#       value = "jdbc:postgresql://${jsondecode(local.mysql.secret_string)["endpoint"]}/${jsondecode(local.mysql.secret_string)["dbname"]}?sslmode=require"
#     },
#   ]
#   log_configuration = {
#     logDriver = "awslogs"
#     options = {
#       "awslogs-region"        = var.aws_region
#       "awslogs-group"         = "/ecs/service/${var.name_prefix}-sonar"
#       "awslogs-stream-prefix" = "ecs"
#     }
#     secretOptions = null
#   }

#   # tags = var.tags
# }
