.PHONY: install up down restart shell artisan migrate fresh seed logs ps

install:
	@bash setup.sh

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down && docker compose up -d

shell:
	docker compose exec app bash

artisan:
	docker compose exec app php artisan $(filter-out $@,$(MAKECMDGOALS))

migrate:
	docker compose exec app php artisan migrate

fresh:
	docker compose exec app php artisan migrate:fresh --seed

seed:
	docker compose exec app php artisan db:seed

logs:
	docker compose logs -f

ps:
	docker compose ps

composer:
	docker compose exec app composer $(filter-out $@,$(MAKECMDGOALS))

%:
	@:
