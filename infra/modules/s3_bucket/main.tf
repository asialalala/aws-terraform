# Creates an S3 bucket and uploads a CSV file to it.
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "file_with_measurements" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = var.key
  source = var.object_source
}
