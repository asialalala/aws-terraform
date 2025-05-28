resource "aws_sfn_state_machine" "my_workflow" {
    name     = var.name
    role_arn = var.role_arn
definition = templatefile("${path.module}/${var.definition}", {
  distributor_lambda_arn    = var.distributor_lambda_arn
  error_handling_lambda_arn = var.error_handling_lambda_arn
  transformer_lambda_arn    = var.transformer_lambda_arn
})
}

