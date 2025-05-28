output "bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
}

output "object_url" {
  value = "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/${aws_s3_object.file_with_measurements.key}"
}