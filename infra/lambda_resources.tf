
data "archive_file" "distributor" {
    type        = "zip"
    source_dir  = "../src/lambda/distributor/"
    output_path = "../src/lambda/dist/distributor.zip"
}

data "archive_file" "error-handler" {
    type        = "zip"
    source_dir  = "../src/lambda/error-handler/"
    output_path = "../src/lambda/dist/error-handler.zip"
}

data "archive_file" "transformer" {
    type        = "zip"
    source_dir  = "../src/lambda/transformer/"
    output_path = "../src/lambda/dist/transformer.zip"
}
