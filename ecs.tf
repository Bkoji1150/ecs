

module required_tags {
  source = "git::git@github.com:Bkoji1150/kojitechs-tf-aws-required-tags.git" 

  line_of_business        = var.line_of_business 
  ado                     = "Kojitechs"
  tier                    = var.tier 
  operational_environment = terraform.workspace
  tech_poc_primary        = "Analytics@Kojitechs.io"
  tech_poc_secondary      = "Analytics@Kojitechs.io"
  application             = "HQR"
  builder                 = "kojibello058@gmail.com"
  application_owner       = "Analytics@Kojitechs.io"
  vpc                     = "APP"
  cell_name               = var.cell_name 
  component_name          = var.component_name 
}

resource "aws_ecs_cluster" "test-cluster" {
  name = local.cluster_name
}

data "template_file" "testapp" {
  template = file("./templates/image/image.json")

  vars = {
    app_image = lower(var.container_source) == "ecr" ? format(
      "%s.dkr.ecr.us-east-1.amazonaws.com/%s:%s",
      var.ecr_account_id,
      var.container_name,
      var.container_version
    ) : ""
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "test-def" {
  family                   = "testapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.testapp.rendered
}

resource "aws_ecs_service" "test-service" {
  name            = "testapp-service"
  cluster         = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.test-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = "testapp"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
