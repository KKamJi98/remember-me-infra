# lambda_function.py
def lambda_handler(event, context):
    # Call the function from the layer
    message = hello_world()
    return {
        "statusCode": 200,
        "body": message
    }
