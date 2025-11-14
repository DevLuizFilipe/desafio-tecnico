resource "aws_s3_object" "object" {
  bucket = var.bucket_name
  key    = "index.html"
  source = "../front/index.html"
  acl    = "public-read"
  content_type = "text/html"
}
