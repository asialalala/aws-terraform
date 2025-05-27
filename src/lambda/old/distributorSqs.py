import datetime
from io import StringIO
from datetime import datetime
from datetime import timedelta
import boto3

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

SQS_QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/486760603738/sensorDataQueue'
BUCKET_NAME = 'cauchybellmanmondostaticdata'
FILE_KEY = 'sensor-1k.csv'

# The function reads and groups input data, returning a list of groups to the next function
def lambda_handler(event, context):
    try:

        # Define the time window
        time_window = event.get('time_window', 5)  # Default to 5 minutes if not provided
        now_time = datetime.now()
        start_time = now_time - timedelta(minutes=time_window)
        print(f"time_window: {time_window}")

        # Continuously fetch all available data from SQS
        messages = []
        response = sqs_client.receive_message(
        QueueUrl=SQS_QUEUE_URL,
        MaxNumberOfMessages=10,
        MessageAttributeNames=['All'],
        WaitTimeSeconds=20
        )
        if('Messages' in response and response['Messages']):
            for message in response['Messages']:
                # Extract the timestamp from the message attributes
                timestamp = float(message['MessageAttributes']['timestamp']['StringValue'])
                print(f"Timestamp: {timestamp}")
                # Check if the timestamp is within the time window
                print(f"start_time: {start_time}")
                print(f"now_time: {now_time}")
                if start_time.timestamp() <= timestamp <= now_time.timestamp():
                        messages.append(message)
        else:
            print("No messages received from SQS.")
            raise ValueError(f"No messages to process in SQS. Response: {messages}")


        data = [
            {
            "location_id": message['MessageAttributes']['location_id']['StringValue'],
            "temperature": message['MessageAttributes']['temperature']['StringValue'],
            "timestamp": message['MessageAttributes']['timestamp']['StringValue']
            }
            for message in messages if 'MessageAttributes' in message
        ]

        # Check if data is empty
        if not data:
            raise ValueError("No valid messages to process from SQS")
        
        # Delete messages from SQS after processing
        for message in messages:
            sqs_client.delete_message(
                QueueUrl=SQS_QUEUE_URL,
                ReceiptHandle=message['ReceiptHandle']
            )

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

        # Return grouped data
        return groups

    except ValueError as e:
        print(f"ValueError: {e}")
        raise
    except Exception as e:
        print(f"Unexpected error: {e}")
        raise

# This exception is raised when there is an issue with the input data
class ValueError(Exception):
    pass
