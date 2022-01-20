import json
import boto3
from urllib.parse import unquote_plus

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('s3_metadata')
s3 = boto3.resource('s3')

def put_metadata(metadata):
    table.put_item(Item=metadata)

def handle(event, context):
    print(event)

    for message in event['Records']:
        body = json.loads(message['body'])
        message_json = json.loads(body['Message'])

        for record in  message_json['requestPayload']['Records']:
            print(record)
            bucket_name = record['s3']['bucket']['name']
            key = unquote_plus(record['s3']['object']['key'])

            obj = s3.Object(bucket_name, key)

            put_metadata({
                'ObjectKey' : f'{bucket_name}/{key}',
                'LastModifiedTS': obj.last_modified.strftime('%Y-%m-%dT%H:%M:%S'),
                'LastModifiedDay ': obj.last_modified.strftime('%Y-%m-%d'),
                'ContentLength': obj.content_length,
                'ContentType': obj.content_type,
                'StorageClass': obj.storage_class
            })
