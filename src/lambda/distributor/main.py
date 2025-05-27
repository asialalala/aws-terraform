from io import StringIO
import boto3
import csv
import json

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

SQS_QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/486760603738/sensorDataQueue'
BUCKET_NAME = 'cauchybellmanmondostaticdata'
FILE_KEY = 'sensor-1k.csv'

# The function reads and groups input data, returning a list of groups to the next function
def lambda_handler(event, context):
    try:

        # Get data from S3
        # s3_object = s3_client.get_object(Bucket=BUCKET_NAME, Key=FILE_KEY)
        # csv_string = s3_object['Body'].read().decode('utf-8')
        # csv_reader = csv.DictReader(StringIO(csv_string))
        # data = [row for row in csv_reader]

        # Get data from SQS
        response = sqs_client.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=10,
            MessageAttributeNames=['All'],
            WaitTimeSeconds=20
        )

        print(f"SQS Response: {response}")

        # Check if 'Messages' key exists in the response
        if 'Messages' not in response or not response['Messages']:
            print("No messages received from SQS.")
            return {"status": "No messages to process"}

        messages = response['Messages']
        print(messages)

        data = [json.loads(msg['Body']) for msg in messages]

        # Group data based on the location id
        groups = [
            {
                "type": f"group{location_id}",
                "data": [
                    {"value": float(row['temperature']), "timestamp": row['timestamp']}
                    for row in data if int(row['location_id']) == location_id
                ]
            }
            for location_id in range(1, 6)
        ]

        # Send grouped data to SQS
        for group in groups:
            sqs_client.send_message(
                QueueUrl=SQS_QUEUE_URL,
                MessageBody=json.dumps(group)
            )

        # Return grouped data
        return groups

    except Exception as e:
        print(f"Error: {e}")
        return {"status": "Error", "message": str(e)}