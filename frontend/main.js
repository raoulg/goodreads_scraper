document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('number-form');
  const responseMessage = document.getElementById('response-message');

  form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const numberInput = document.getElementById('number-input');
    const number = numberInput.value;

    const apiGatewayUrl = 'https://qicvm3nqyh.execute-api.eu-central-1.amazonaws.com/prod/hello';

    try {
      const response = await fetch(apiGatewayUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(number)
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const jsonResponse = await response.json();
      responseMessage.textContent = jsonResponse.message;
    } catch (error) {
      console.error('There was a problem with the fetch operation:', error);
      responseMessage.textContent = 'Error: Unable to process the request';
    }
  });
});

