.PHONY: build test interactive clean

build:
	docker build -t julia-lambda-docker .

test: build
	docker run -d --rm --name julia-lambda-docker-instance -p 8080:8080 -e AWS_EXECUTION_ENV=AWS_Lambda_julia julia-lambda-docker
	sleep 2
	curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{}'
	docker stop julia-lambda-docker-instance

interactive: build
	docker run -it --rm --name julia-lambda-docker-instance -p 8080:8080 -e AWS_EXECUTION_ENV=AWS_Lambda_julia --entrypoint /bin/bash julia-lambda-docker

clean:
	docker rmi julia-lambda-docker

# .PHONY: all build run test

# all: build run 
# 	sleep 10
# 	make test

# build:
# 	docker build -t julia-lambda-docker .

# run:
# 	docker run -d --rm --name julia-lambda-docker-instance -p 8080:8080 -e AWS_EXECUTION_ENV=AWS_Lambda_julia --entrypoint /usr/local/bin/aws-lambda-rie julia-lambda-docker julia --function handler app.jl

# interactive:
# 	make build
# 	docker run -it --rm --name julia-lambda-docker-instance -p 8080:8080 -e AWS_EXECUTION_ENV=AWS_Lambda_julia --entrypoint /bin/bash julia-lambda-docker

# test:
# 	curl -X POST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{}' -o response.json
# 	cat response.json
# 	rm response.json
# 	docker stop julia-lambda-docker-instance
