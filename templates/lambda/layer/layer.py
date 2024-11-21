# lambda_function.py
from hello_layer import hello_world

def lambda_handler(event, context):
    # Call the function from the layer
    message = hello_world()
    return {
        "statusCode": 200,
        "body": message
    }
