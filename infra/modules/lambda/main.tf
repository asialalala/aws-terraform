resource "aws_lambda_function" "my_lambda" {
  filename         = var.filename
  source_code_hash = var.source_code_hash
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  reserved_concurrent_executions = var.reserved_concurrent_executions
}