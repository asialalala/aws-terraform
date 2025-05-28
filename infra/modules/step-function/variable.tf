variable "name" { type = string }
variable "role_arn" { type = string }
variable "definition" { 
  type = string 
  default = "workflow.json"
}
variable "distributor_lambda_arn" { type = string }
variable "error_handling_lambda_arn" { type = string }
variable "transformer_lambda_arn" { type = string }