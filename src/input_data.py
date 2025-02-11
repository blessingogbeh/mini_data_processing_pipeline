import boto3
import json
import base64

# Initialize a session using Amazon Kinesis
kinesis_client = boto3.client('kinesis', region_name='us-east-1')

# Define the Kinesis stream name
stream_name = 'data_stream'

# Load the sample JSON data from a file
with open('sample_data/stream_all_data.json', 'r') as file:
    data = json.load(file)

# Iterate over each record in the JSON data
#     # Encode the Data field to base64
for record in data['Records']:
    print('record:', record)
    json_string = json.dumps(record['Data'])
    print('json_string:', json_string)
    encoded_bytes = base64.b64encode(json_string.encode('utf-8'))
    encoded_data = encoded_bytes.decode('utf-8')
    print('encoded_data:', encoded_data)

# Push the record to the Kinesis stream
    response = kinesis_client.put_record(
        StreamName=stream_name,
        Data=encoded_data,
        PartitionKey=record['PartitionKey']
    )

    # Print the response from Kinesis
    #print(response)
    #print('encoded_data:', encoded_data)