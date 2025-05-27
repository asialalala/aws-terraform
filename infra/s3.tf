# Creates an S3 bucket and uploads a CSV file to it.
resource "aws_s3_bucket" "my_bucket" {
  bucket = "backetdatafromterraformforlab4"
}

resource "aws_s3_object" "file_with_measurements" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "sensor-1k.csv"
  source = "../data/sensor-1k.csv"
}
