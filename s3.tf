resource "aws_s3_bucket" "prod_media" {
  bucket = "${var.s3_binary_bucket}"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]

    allowed_origins = ["https://www.test.com/*",",
    ]

    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  versioning {
    enabled = true
  }

  tags {
    Name        = "Binary File Storage"
    environment = "${var.tag_environment}"
  }
}
