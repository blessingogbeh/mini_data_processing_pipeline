# Create S3 bucket for Lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "mdpp-lambda-code-bucket"
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "lambda_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}