module "my_bucket" {
  source = "./modules/s3_bucket"
  bucket_name = "backetdatafromterraformforlab4"
  key         = "sensor-1k.csv"
  object_source = "../data/sensor-1k.csv"
}

