variable "bucket_name" { type = string }
variable "key" { 
    type = string
    default = "sensor-1k.csv" 
}
variable "object_source" { 
    type = string
    default = "../data/sensor-1k.csv" 
  
}