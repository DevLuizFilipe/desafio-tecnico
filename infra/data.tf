data "aws_vpc" "main" {
  depends_on = [ module.vpc ]
  filter {
    name   = "tag:Name"
    values = [var.vpc[0].name]
  }
}
