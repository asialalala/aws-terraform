import json
import boto3

# Def clients
sns_client = boto3.client('sns')
SNS_TOPIC = 'arn:aws:sns:us-east-1:486760603738:SEND_ERROR_CODE'

def lambda_handler(event, context):

    # Send SNS notification
    sns_client.publish(
    TopicArn = SNS_TOPIC,
    Subject = 'Error during distribution.',
    Message = 'One or more errors occurred during distributing the data. Probably no records are available to process in the SQS queue. '
    )
   
    return {
        'body': json.dumps('Error(s) occurred during distribution.')
    }
