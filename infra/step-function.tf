resource "aws_sfn_state_machine" "workflow" {
    name     = "workflow"
    role_arn = data.aws_iam_role.lab_role.arn

    definition = <<EOF
{
  "Comment": "Workflow for processing sensor data",
  "StartAt": "distributor",
  "States": {
    "distributor": {
      "Type": "Task",
      "Resource": "${module.distributor_lambda.lambda_function_arn}",
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "HandleError",
          "ResultPath": null
        }
      ],
      "Next": "Map"
    },
    "HandleError": {
      "Type": "Task",
      "Resource": "${module.error_handling_lambda.lambda_function_arn}",
      "End": true
    },
    "Map": {
      "Type": "Map",
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "INLINE"
        },
        "StartAt": "dataTransform",
        "States": {
          "dataTransform": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "OutputPath": "$.Payload",
            "Parameters": {
              "FunctionName": "${module.transformer_lambda.lambda_function_arn}",
              "Payload.$": "$"
            },
            "Retry": [
              {
                "ErrorEquals": [
                  "Lambda.ServiceException",
                  "Lambda.AWSLambdaException",
                  "Lambda.SdkClientException",
                  "Lambda.TooManyRequestsException"
                ],
                "IntervalSeconds": 1,
                "MaxAttempts": 3,
                "BackoffRate": 2,
                "JitterStrategy": "FULL"
              }
            ],
            "End": true
          }
        }
      },
      "End": true
    }
  }
}
EOF
}

