.DEFAULT_GOAL := test
.PHONY: test

build:
	docker build -t julia-lambda-docker .

test: build
	make run
	sleep 2
	curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{"number": 12972560}'
	docker stop julia-lambda-docker-instance

run:
	make key
	docker run -d --rm --name julia-lambda-docker-instance \
		-p 8080:8080 \
		--env-file ENV.txt \
		-e AWS_EXECUTION_ENV=AWS_Lambda_julia julia-lambda-docker

clean:
	docker rmi julia-lambda-docker

stop:
	docker stop julia-lambda-docker-instance

log:
	docker logs -f julia-lambda-docker-instance

key: ENV.txt

ENV.txt:
	@echo "Enter the value for OPENAI_KEY (input will be hidden):"
	@stty -echo
	@read OPENAI_KEY; \
	stty echo; \
	echo "OPENAI_KEY=$$OPENAI_KEY" > ENV.txt
	@echo "ENV.txt file has been created with the provided OPENAI_KEY value."