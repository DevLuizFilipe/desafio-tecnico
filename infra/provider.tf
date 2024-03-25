provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env
      Region      = var.region
      App         = var.app_name
      Description = "Resource created by Terraform"
    }
  }
}
