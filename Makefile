# Makefile for ikaros-MIMA
# Based on work by Viral Ganatra (https://github.com/viralganatra/docker-nodejs-best-practices ) under the MIT license
#
SHELL=bash

###################################################################################################
## INITIALISATION
###################################################################################################

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
.DEFAULT_GOAL := help

###################################################################################################
## GIT 
###################################################################################################
.PHONY: pull sync

pull: ##@git Pull new data from github
	git pull
	
sync: ##@git Add, commit and sync all files with git repository (the env var COMMENT is passed as commit -m message)
	git add --all
	git commit -m "$(COMMENT)"
	git pull
	git push


###################################################################################################
## APP 
###################################################################################################
.PHONY: build build-no-cache start start-detached stop shell

build: ##@app Build the application with all containers
	docker compose build

build-no-cache: ##@app Build the application without using cache
	docker compose build --no-cache

start: ##@app Start the environment
	docker compose up

start-detached: ##@app Start the environment (detached)
	docker compose up -d

stop: ##@app Stop the environment
	docker compose down
refresh: ##@app Pull code, build and restart all containers
	@echo "Pull code, build and restart all containers"
	@echo ""
	git pull
	docker compose build	
	docker compose down
	docker compose up -d

refresh-app: ##@app Pull code, build and restart the prod container
	@echo "Pull code, build and restart the prod container"
	@echo ""
	git pull
	docker compose -d --force-recreate --no-deps --build khm-prosjektering-pdb-prod

shell: ##@app Go into the running container (the env var APP should match what's in docker-compose.yml)
	@echo "Go into the running container (the env var APP should match what's in docker-compose.yml)"
	@echo ""
	docker compose exec $(APP) /bin/sh

prune: ##@app Remove all stopped containers, and volumes, networks and images not used by/associated with a container
	@echo "Remove all stopped containers, and volumes, networks and images not used by/associated with a container"
	@echo "Using docker system prune -a"
	@echo ""
	docker system prune -a	

###################################################################################################
## HELP
###################################################################################################

.PHONY: default
default: help

GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
