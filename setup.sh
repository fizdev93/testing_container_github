#!/usr/bin/env bash
set -e

echo "==> Building and starting Docker containers..."
docker compose up -d --build

echo "==> Waiting for containers to be ready..."
sleep 5

echo "==> Installing Laravel 11..."
docker compose exec app composer create-project laravel/laravel . "^11.0"

echo "==> Configuring .env for PostgreSQL..."
docker compose exec app bash -c "
  sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/' .env
  grep -q '^DB_HOST' .env && sed -i 's/^DB_HOST=.*/DB_HOST=postgres/' .env || echo 'DB_HOST=postgres' >> .env
  grep -q '^DB_PORT' .env && sed -i 's/^DB_PORT=.*/DB_PORT=5432/' .env || echo 'DB_PORT=5432' >> .env
  grep -q '^DB_DATABASE' .env && sed -i 's/^DB_DATABASE=.*/DB_DATABASE=laravel/' .env || echo 'DB_DATABASE=laravel' >> .env
  grep -q '^DB_USERNAME' .env && sed -i 's/^DB_USERNAME=.*/DB_USERNAME=laravel/' .env || echo 'DB_USERNAME=laravel' >> .env
  grep -q '^DB_PASSWORD' .env && sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=secret/' .env || echo 'DB_PASSWORD=secret' >> .env
"

echo "==> Generating application key..."
docker compose exec app php artisan key:generate

echo "==> Running migrations..."
docker compose exec app php artisan migrate

echo ""
echo "==> Setup complete!"
echo "    App: http://localhost:8080"
echo "    DB:  localhost:5432 (laravel/laravel/secret)"
