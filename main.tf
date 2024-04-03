provider "aws" {
  region = "us-east-1" # Specify your AWS region
}

resource "aws_s3_bucket" "frontend_app" {
  bucket = "your-frontend-app-${var.environment}" # Ensure the bucket name 
is unique
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "frontend_app_policy" {
  bucket = aws_s3_bucket.frontend_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = ["${aws_s3_bucket.frontend_app.arn}/*"]
        Principal = "*"
      },
    ]
  })
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

