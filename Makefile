DOCKER-RUN = docker compose run --rm web
BUNDLE-RUN = bundle exec

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
	$(DOCKER-RUN) $(BUNDLE-RUN) rubocop
