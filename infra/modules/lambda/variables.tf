variable "filename" { type = string }
variable "source_code_hash" { type = string }
variable "function_name" { type = string }
variable "role_arn" { type = string }
variable "handler" { type = string }
variable "runtime" { 
    type = string
    default = "python3.8" 
    }
variable "reserved_concurrent_executions" { 
    type = number 
    default = 3 
    }