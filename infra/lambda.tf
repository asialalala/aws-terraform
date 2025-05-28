module "distributor_lambda" {
  source = "./modules/lambda"
  filename = data.archive_file.distributor.output_path
  source_code_hash = data.archive_file.distributor.output_base64sha256
  function_name = "distributor_lambda"
  role_arn = data.aws_iam_role.lab_role.arn
  handler       = "distributor/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}

module "error_handling_lambda" {
  source = "./modules/lambda"
  filename = data.archive_file.error-handler.output_path
  source_code_hash = data.archive_file.error-handler.output_base64sha256
  function_name = "error-handler_lambda"
  role_arn = data.aws_iam_role.lab_role.arn
  handler       = "error-handler/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}

module "transformer_lambda" {
  source = "./modules/lambda"
  filename = data.archive_file.transformer.output_path
  source_code_hash = data.archive_file.transformer.output_base64sha256
  function_name = "transformer_lambda"
  role_arn = data.aws_iam_role.lab_role.arn
  handler       = "transformer/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}
