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

terraform {
  required_version = ">= 1.11.0"
  backend "s3" {
    bucket       = "squad-terraform-tfstate"
    key          = "terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}
