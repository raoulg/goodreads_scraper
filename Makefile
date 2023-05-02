.DEFAULT_GOAL := key
.PHONY: help all build serve key

help:
	@echo "Usage: make [target]"
	@echo "make build"
	@echo "	builds docker image 'scrape'"

all:
	make key
	make build
	make serve


key: ENV.txt

ENV.txt:
	@echo "Enter the value for OPENAI_KEY (input will be hidden):"
	@stty -echo
	@read OPENAI_KEY; \
	stty echo; \
	echo "OPENAI_KEY=$$OPENAI_KEY" > ENV.txt
	@echo "ENV.txt file has been created with the provided OPENAI_KEY value."


build:
	docker build -t scrape .

serve:
	@echo "Open the server at http://localhost:8080/docs for a schema"
	@echo "Open http://localhost:8080/scrape/id where id is a goodreads book id,"
	@echo "E.g. http://localhost:8080/scrape/9076975"
	@echo "test healt at http://localhost:8080/health"
	docker run --rm \
		--env-file ENV.txt \
		-p 8080:8080 \
		-v $$(pwd)/data:/app/data scrape \
		--project=. scrape.jl
