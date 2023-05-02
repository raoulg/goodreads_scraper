const AWS = require('aws-sdk');

exports.handler = async (event) => {
  try {
    const number = parseInt(JSON.parse(event.body));
    const message = `Hello world ${number}`;

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*', // Add this line
      },
      body: JSON.stringify({ message }),
    };
  } catch (error) {
    console.error('Error processing request:', error);

    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*', // Add this line
      },
      body: JSON.stringify({ message: 'An error occurred' }),
    };
  }
};

