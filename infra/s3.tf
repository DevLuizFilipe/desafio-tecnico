resource "aws_s3_bucket" "bucket-front-end" {
  bucket = "globo-desafio-tecnico-devops"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "object" {
  bucket = module.bucket-front-end.s3_bucket_id
  key    = "index.html"
  source = "../front/index.html"
  acl    = "public-read"
}
