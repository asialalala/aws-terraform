# Get data from the AWS provider.
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Creates SQS queue that receives data from the distributor Lambda function.
resource "aws_sqs_queue" "data_queue" {
  name = "data-queue"
}
