variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
}


variable "listener_port" {
  default = "80"
}

variable "env" {
  type = map(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}


variable "name_prefix" {
  description = ""
  type        = string
  default     = "kojitechs-sonar-app"
}

variable "lb_enable_cross_zone_load_balancing" {
  type        = string
  default     = "true"
  description = "Enable cross zone support for LB"
}


variable "lb_http_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type        = map(any)
  default = {
    listener_port         = 80
    target_group_port     = 9000
    target_group_protocol = "HTTP"
  }
}

variable "lb_https_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type        = map(any)
  default = {
    listener_port         = 443
    target_group_port     = 9000
    target_group_protocol = "HTTP"
  }
}

#------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER LOGS
#------------------------------------------------------------------------------
variable "enable_s3_logs" {
  description = "(Optional) If true, all resources to send LB logs to S3 will be created"
  type        = bool
  default     = true
}

variable "block_s3_bucket_public_access" {
  description = "(Optional) If true, public access to the S3 bucket will be blocked."
  type        = bool
  default     = true
}

variable "enable_s3_bucket_server_side_encryption" {
  description = "(Optional) If true, server side encryption will be applied."
  type        = bool
  default     = true
}

variable "s3_bucket_server_side_encryption_sse_algorithm" {
  description = "(Optional) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
  default     = "aws:kms"
}

variable "s3_bucket_server_side_encryption_key" {
  description = "(Optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
  type        = string
  default     = "aws/s3"
}

#------------------------------------------------------------------------------
# Sonarqube image version
#------------------------------------------------------------------------------
variable "sonarqube_image" {
  description = "Sonarqube image"
  type        = string
  default     = "sonarqube:lts"
}

variable "enable_autoscaling" {
  type        = bool
  default     = false
  description = "Enable auto scaling for datacenter edition"
}


variable "ephemeral_storage_size" {
  type        = number
  description = "The number of GBs to provision for ephemeral storage on Fargate tasks. Must be greater than or equal to 21 and less than or equal to 200"
  default     = 0
}

#------------------------------------------------------------------------------
# Sonarqube SSL settings
#------------------------------------------------------------------------------
variable "enable_ssl" {
  description = "Enable SSL"
  type        = bool
  default     = true
}

variable "dns_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(any)

}

variable "cluster_name" {
  description = "Name of the ECS cluster to deploy the service into."
  type        = string
  default     = null
}

variable "tier" {
  description = "Canonical name of the application tier"
  type        = string
  default     = "APP"
}

variable "cell_name" {
  description = "Name of the cell."
  type        = string
  default     = "reporting-frontend"
}
