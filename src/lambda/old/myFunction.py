import json
import math
import random
from datetime import datetime
import boto3

# Define const for equation
a = 1.4*10**(-3)
b = 2.37*10**(-4)
c = 9.90*10**(-8)

# Def to send by sns
SNS_TOPIC = 'arn:aws:sns:us-east-1:486760603738:SEND_ERROR_CODE'
sns_client = boto3.client('sns')
dynamodb_client = boto3.resource('dynamodb')
sqs_client = boto3.client('sqs')

SQS_QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/486760603738/sensorDataQueue'
TABLE_NAME = 'SensorData'
table = dynamodb_client.Table(TABLE_NAME)

def send_to_sqs(message_body, message_attributes):
    response = sqs_client.send_message(
        QueueUrl=SQS_QUEUE_URL,
        MessageBody=message_body,  # Corrected parameter name
        MessageAttributes=message_attributes
    )
    return response

def count_temperature(R, sensor_id):
    T = 1/(a+b*math.log(R)+c*(math.log(R)**3))

    T = T - 273.15  # Convert from Kelvin to Celsius
    
    if(T > -273.15 and T <= 20):
        status = 'TEMPERATURE TOO LOW'
    elif(T > 20 and T <= 100):
        status = 'OK'
    elif(T > 100 and T <= 250):
        status = 'TEMPERATURE TOO HIGH'
    elif(T > 250):
        status = 'TEMPERATURE CRITICAL'
        
        # Send SNS notification
        sns_client.publish(
            TopicArn=SNS_TOPIC,
            Subject='Status ' + str(status) + ' on sensor ' + str(sensor_id),
            Message='The temperature is too high!!!!'
        )
    return (T, status)

def lambda_handler(event, context):
    R = event['value']
    sensor_id = event['sensor_id']

    # Check if the sensor is broken
    broken = table.get_item(Key={'sensor_id': str(sensor_id)})
    if 'Item' in broken:
        error = 'BROKEN SENSOR'
        return {'error': error}
    
    # Check the range of R
    if(R < 1 or R > 2*10**3):
        error = 'VALUE OUT OF RANGE'
        table.put_item(Item={"sensor_id": str(sensor_id), "broken": True})
        return {'error': error}

    (T, status) = count_temperature(R, sensor_id)
    # Send data to SQS
    message_attributes = {
        'sensor_id': {
            'DataType': 'String',
            'StringValue': str(sensor_id)
        },
        'location_id': {
            'DataType': 'String',
            'StringValue': str(sensor_id % 5 + 1)
        },
        'temperature': {
            'DataType': 'Number',
            'StringValue': str(T)
        },
        'timestamp': {
            'DataType': 'Number',
            'StringValue': str(datetime.now().timestamp())
        }
    }
    message_body = f"{status}"
    resp = send_to_sqs(message_body, message_attributes)
    print("Send to SQS response ", resp)
        
    return {'status': status}
