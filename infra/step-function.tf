module "workflow" {
    source = "./modules/step-function"
    name     = "workflow"
    role_arn = data.aws_iam_role.lab_role.arn
    definition = "workflow.json"
    distributor_lambda_arn    = module.distributor_lambda.lambda_function_arn
    error_handling_lambda_arn = module.error_handling_lambda.lambda_function_arn
    transformer_lambda_arn    = module.transformer_lambda.lambda_function_arn
}

