import json
from lambda_function import lambda_handler


def test_lambda_handler():
    event = {
        "number": 42
    }
    context = MockContext()
    response = lambda_handler(event, context)
    
    # assert something about the response
    # for example, that the status code is 200
    assert response['statusCode'] == 200
    # and the returned number is 42
    assert json.loads(response['body'])['number'] == 42