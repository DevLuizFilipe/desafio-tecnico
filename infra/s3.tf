resource "aws_s3_bucket_object" "object" {
  bucket = "globo-desafio-tecnico-devops"
  key    = "index.html"
  source = "../front/index.html"
  acl    = "public-read"
}
