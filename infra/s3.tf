resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "index.html"
  source = "../front/index.html"
  acl    = "public-read"
}
