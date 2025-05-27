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
      "Resource": "${aws_lambda_function.error_handling_lambda.arn}",
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
      "Resource": "${aws_lambda_function.error_handling_lambda.arn}",
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
              "FunctionName": "${aws_lambda_function.transformer_lambda.arn}",
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

