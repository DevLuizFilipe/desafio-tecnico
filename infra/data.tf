data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc[0].name]
  }
}
