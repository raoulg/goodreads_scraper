.DEFAULT_GOAL := help
.PHONY: test build run clean stop log key help

# Build the Docker container
build:
	@echo "Building Docker container..."
	docker build -t julia-lambda-docker .

# Test the application
test: build
	@echo "Running test..."
	make run
	sleep 2
	curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{"number": 12972560}'
	docker stop julia-lambda-docker-instance

# Run the Docker container
run:
	@echo "Running Docker container..."
	make key
	docker run -d --rm --name julia-lambda-docker-instance \
		-p 8080:8080 \
		--env-file ENV.txt \
		-e AWS_EXECUTION_ENV=AWS_Lambda_julia julia-lambda-docker

# Remove the Docker container
clean:
	@echo "Removing Docker container..."
	docker rmi julia-lambda-docker

# Stop the Docker container
stop:
	@echo "Stopping Docker container..."
	docker stop julia-lambda-docker-instance

# Show the logs of the Docker container
log:
	@echo "Displaying logs of Docker container..."
	docker logs -f julia-lambda-docker-instance

# Create the ENV.txt file containing the OPENAI_KEY value
key: ENV.txt

ENV.txt:
	@echo "Enter the value for OPENAI_KEY (input will be hidden):"
	@stty -echo
	@read OPENAI_KEY; \
	stty echo; \
	echo "OPENAI_KEY=$$OPENAI_KEY" > ENV.txt
	@echo "ENV.txt file has been created with the provided OPENAI_KEY value."

# Display help information
help:
	@echo "Makefile commands:"
	@echo "  build    - Build the Docker container"
	@echo "  test     - Test the application"
	@echo "  run      - Run the Docker container"
	@echo "  clean    - Remove the Docker container"
	@echo "  stop     - Stop the Docker container"
	@echo "  log      - Show the logs of the Docker container"
	@echo "  key      - Create the ENV.txt file containing the OPENAI_KEY value"
	@echo "  help     - Display help information"
