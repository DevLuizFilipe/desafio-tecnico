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

resource "aws_ecrpublic_repository" "comments" {
  provider        = aws.us_east_1
  repository_name = var.ecr[0].name
}
