import json
import boto3

# Def clients
s3_client = boto3.client('s3')

BUCKET_NAME = 'cauchybellmanmondostaticdata'
FILE_KEY = 'invalid_records.csv'

def lambda_handler(event, context):

    # Define bucket name
    # Get data from S3
    s3_object = s3_client.get_object(Bucket=BUCKET_NAME, Key=FILE_KEY)
    
    transaction_to_upload = {}
    transaction_to_upload = event
    bucket_name = 'error-records-bucket'

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
