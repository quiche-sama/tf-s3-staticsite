provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "site" {
  bucket = var.site_domain
    website {
      index_document = "index.html"
      error_document = "error.html"
    }
  acl = "public-read"


}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      },
    ]
  })
}
resource "aws_s3_object " "index" {
  # Must have bucket versioning enabled first
  key = "index.html"
  bucket = aws_s3_bucket.site.id
  source = "index.html"
}