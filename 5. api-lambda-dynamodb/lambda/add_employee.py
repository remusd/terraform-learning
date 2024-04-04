import boto3
import json
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('employees')

def lambda_handler(event, context):
    request = json.loads(event["body"])
    response = table.put_item(
        Item={
            "employee_id"   : request["employee_id"],
            "name"          : request["name"],
            "business_unit" : request["business_unit"],
            "cubicle_no"    : request["cubicle_no"]
        }
    )

    return {
        'statusCode': 200,
        'body': '{"status":"Product created"}'
    }