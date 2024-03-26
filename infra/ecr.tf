resource "aws_ecr_repository" "main" {
  count = var.create_ecr ? length(var.ecr) : 0

  name                 = var.ecr[0].name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
