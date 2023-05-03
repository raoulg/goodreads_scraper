.DEFAULT_GOAL := test
.PHONY: test

test-julia:
	julia -e 'include("lambda_handler.jl"); event = "{\"path\": \"/scrape/1489741\"}"; context = nothing; response = handler(event, context); println(response);'

test-docker:
	docker build -t my-julia-lambda .
	docker run -d -p 9000:9001 my-julia-lambda
	curl -XPOST "http://localhost:9000/2018-06-01/runtime/invocation/1/event" -d '{"path": "/scrape/1489741"}'