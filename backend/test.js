const { handler } = require('./index');

const sampleEvent = {
  body: JSON.stringify(42),
};

(async () => {
  try {
    const result = await handler(sampleEvent);
    console.log('Result:', result);
  } catch (error) {
    console.error('Error:', error);
  }
})();

