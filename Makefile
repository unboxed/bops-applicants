DOCKER-RUN = docker compose run --rm web

.DEFAULT_GOAL := up

build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

prompt:
	$(DOCKER-RUN) bash

lint:
	$(DOCKER-RUN) rubocop
