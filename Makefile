# Makefile for common tasks in this lab
COMPOSE=docker compose

default: help

help:
	@printf "Usage:\n"
	@printf "  make up       # start containers\n"
	@printf "  make down     # stop and remove containers\n"
	@printf "  make restart  # restart db service\n"
	@printf "  make logs     # show postgres logs\n"
	@printf "  make backup   # create a DB backup (runs scripts/backup.sh)\n"
	@printf "  make restore  # restore from a backup (runs scripts/restore.sh <file>)\n"

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart db

logs:
	docker logs -f pgsql || true

backup:
	./scripts/backup.sh

restore:
	@echo "Use: make restore FILE=./postgres.backup"
	@if [ -z "${FILE}" ]; then echo "Please set FILE=path"; exit 2; fi
	./scripts/restore.sh "${FILE}"

shell:
	$(COMPOSE) exec db bash
