variable "aws_region" {
  default     = "us-east-2"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "myip" {
  default = "0.0.0.0/0"
}
variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}
variable "listener_port" {
  default = "80"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "container_name" {
  description = ""
  type        = string
  default     = "flask"
}

variable "min_capacity" {
  description = "The Minimum capacity of instance to run"
  type        = number
  default     = 2
}
variable "app_port" {
  default     = "8080"
  description = "portexposed on the docker image"
}

variable "app_count" {
  description = "numer of docker containers to run"
  default     = "1"

}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}
variable "container_source" {
  default = "ecr"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}

variable "container_version" {
  description = "Please Provide the latest version of the app"
  type        = string
}
