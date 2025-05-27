resource "aws_lambda_function" "distributor_lambda" {
  filename = data.archive_file.distributor.output_path
  source_code_hash = data.archive_file.distributor.output_base64sha256
  function_name = "distributor_lambda"
  role = data.aws_iam_role.lab_role.arn
  handler       = "distributor/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}

resource "aws_lambda_function" "error_handling_lambda" {
  filename = data.archive_file.error-handler.output_path
  source_code_hash = data.archive_file.error-handler.output_base64sha256
  function_name = "error-handler_lambda"
  role = data.aws_iam_role.lab_role.arn
  handler       = "error-handler/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}

resource "aws_lambda_function" "transformer_lambda" {
  filename = data.archive_file.transformer.output_path
  source_code_hash = data.archive_file.transformer.output_base64sha256
  function_name = "transformer_lambda"
  role = data.aws_iam_role.lab_role.arn
  handler       = "transformer/main.lambda_handler"
  runtime       = "python3.8"
  reserved_concurrent_executions = 3
}
