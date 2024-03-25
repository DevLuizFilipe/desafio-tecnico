# module "bucket-front-end" {
#   source                  = "terraform-aws-modules/s3-bucket/aws"
#   version                 = "3.13.0"
#   bucket                  = "globo-desafio-tecnico-devops"
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
#   acl                     = "public-read"

#   website = {
#     index_document = "index.html"
#   }
# }

# resource "aws_s3_bucket_object" "object" {
#   bucket = module.bucket-front-end.s3_bucket_id
#   key    = "index.html"
#   source = "../front/index.html"
#   acl    = "public-read"
# }
