## Backend
1. AWS starts the Docker container (with the bootstrap script as the entry point).
2. The bootstrap script runs in an infinite loop, waiting for events from the Lambda RIE.
3. When an event is received, the bootstrap script runs the handler function in lambda_handler.jl with the event data and returns the response.
4. The bootstrap script sends the response back to the Lambda RIE using a curl POST request.