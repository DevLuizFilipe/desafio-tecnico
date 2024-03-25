terraform {
  required_version = ">= 1.0.0"
}

###############
# Collect data
###############

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.network_tag}"]

  }
}

resource "aws_iam_role" "ECSTaskExecutionRole" {
  name = "${var.name}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# ######
# # Security Groups
# ######
resource "aws_security_group" "fargate_container_sg" {
  description = "Allow access to the public facing load balancer"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Ingress from the private ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb_access.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.remote_cidr_blocks
  }

}

resource "aws_security_group_rule" "fargate_container_sg_rule" {
  type                     = "ingress"
  security_group_id        = aws_security_group.fargate_container_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.fargate_container_sg.id
}

######
# ECS
######

resource "aws_ecs_cluster" "ecs_fargate" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = var.service_name
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ECSTaskExecutionRole.arn


  container_definitions = jsonencode(
    [
      {
        "cpu" : var.container_cpu,
        "image" : var.image_url,
        "memory" : var.container_memory,
        "name" : var.service_name
        "portMappings" : [
          {
            "containerPort" : var.container_port,
          }
        ]
      }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  depends_on                         = [aws_lb.main]
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.ecs_fargate.id
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "75"
  desired_count                      = var.desired_count
  network_configuration {
    subnets         = data.aws_subnets.subnets.ids
    security_groups = [aws_security_group.fargate_container_sg.id]
  }
  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.ecs_task.family}:${max(aws_ecs_task_definition.ecs_task.revision, aws_ecs_task_definition.ecs_task.revision)}"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }
}

######
# Set up load balancer
######
resource "aws_security_group" "lb_access" {
  description = "Allow access to the public facing load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow public access to fargate ECS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.remote_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.remote_cidr_blocks
  }
}

resource "aws_lb" "main" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = "30"
  security_groups    = [aws_security_group.lb_access.id]
  subnets            = data.aws_subnets.subnets.ids

  depends_on = [data.aws_subnets.subnets]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = var.routing_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = [var.lb_path]
    }
  }
}

######
# Route traffic to the containers via traffic groups
######

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  health_check {
    path              = "/"
    protocol          = "HTTP"
    port              = var.container_port
    timeout           = "5"
    healthy_threshold = "2"
    interval          = "6"
  }
  vpc_id = var.vpc_id
}
