import json
from scrape import main, Settings

settings = Settings(
    "https://www.goodreads.com/book/show/id/reviews",
    ".Formatted",
    ".Text.H1Title",
    5,
    "data",
    1500,
    "gpt-4"
)

def lambda_handler(event, context):
    number = event.get('number')
    summary = main(number, settings)
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS, POST',
    }

    return {
        'statusCode': 200,
        'headers': headers,
        'body': json.dumps({
            'number': number,
            'summary': summary
        })
    }