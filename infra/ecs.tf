module "ecs-fargate" {
  source = "git::https://github.com/DevLuizFilipe/terraform-aws-ecs-fargate"
  count  = var.create_ecs ? length(var.ecs) : 0

  region             = var.region
  vpc_id             = data.aws_vpc.main.id
  name               = var.ecs[0].name
  container_cpu      = var.ecs[0].container_cpu
  container_memory   = var.ecs[0].container_memory
  container_port     = var.ecs[0].container_port
  image_url          = var.ecs[0].image_url
  desired_count      = var.ecs[0].desired_count
  network_tag        = var.ecs[0].network_tag
  remote_cidr_blocks = var.ecs[0].remote_cidr_blocks
  service_name       = var.ecs[0].service_name
}
