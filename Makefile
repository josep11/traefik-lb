## Help
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
		helpCommand = $$1; \
		helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	gsub("\\\\", "", helpCommand); \
	gsub(":+$$", "", helpCommand); \
		printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

## Create local SSL certificates for josep.co
ssl/josep:
	cd ./docker/traefik/certificates && mkcert -install "*.josep.co"

## Restart base stack resources
docker/restart: docker/stop docker/start

## Start base stack resources
docker/start:
	docker-compose up -d --remove-orphans

## Stop base stack resources
docker/stop:
	docker-compose down --remove-orphans

## Start base stack resources. Alias for: docker/start
start: docker/start

## Stop base stack resources. Alias for: docker/stop
stop: docker/stop

## Restart base stack resources. Alias for: docker/restart
restart: docker/restart

default: help
