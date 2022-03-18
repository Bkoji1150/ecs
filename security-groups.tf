# security group creation and attcahing in ecs, alb etc

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "alb-sg" {
  name        = "testapp-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.myip]
  }
  ingress {
    protocol    = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = [var.myip]
  }
  ingress {
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = [var.myip]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "testapp-load-balancer-security-group"
  }

}

resource "aws_security_group" "ecs_https" {
  name        = "ecs_https"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.myip]
  }
  ingress {
    protocol    = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = [var.myip]
  }
  ingress {
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = [var.myip]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecs_https"
  }

}

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_sg" {
  name        = "testapp-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "testapp-ecs-tasks-security-group"
  }

}
