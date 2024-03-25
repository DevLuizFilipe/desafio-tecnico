provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.env
      Region      = var.region
      App         = var.app_name
      Description = "Resource created by Terraform"
    }
  }
}

resource "aws_ecr_repository" "main" {
  count = var.create_ecr ? length(var.ecr) : 0

  name                 = var.ecr[0].name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
