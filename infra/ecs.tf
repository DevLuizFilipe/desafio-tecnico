module "ecs-fargate" {
  source = "./modules/"
  count  = var.create_ecs ? length(var.ecs) : 0

  region             = var.region
  vpc_id             = data.aws_vpc.main.id
  name               = var.ecs[0].name
  container_cpu      = var.ecs[0].container_cpu
  container_memory   = var.ecs[0].container_memory
  container_port     = var.ecs[0].container_port
  image_url          = var.ecs[0].image_url
  desired_count      = var.ecs[0].desired_count
  public_subnets     = var.ecs[0].public_subnets
  private_subnets    = var.ecs[0].private_subnets
  remote_cidr_blocks = var.ecs[0].remote_cidr_blocks
  service_name       = var.ecs[0].service_name
}
