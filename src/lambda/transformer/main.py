# counts the mean of all the values in the currently available bucket 
import json

def lambda_handler(event, context):
    data = event['data']

    if not data:
        return {"status": "No data to process"}

    # Extract temperatures and timestamps
    temperatures = [item['temperature'] for item in data]

    # timestamps = [item['timestamp'] for item in data] <-- For later use
    
    mean_value = sum(temperatures) / len(temperatures)
    return {
        'mean_value': mean_value,
    }
