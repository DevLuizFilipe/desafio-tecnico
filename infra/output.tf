output "lb_dns" {
  value = module.ecs-fargate[0].lb_dns_name
}
