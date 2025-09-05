#!/bin/sh
set -e  # exit if any command fails

echo "Waiting for PostgreSQL at $DB_HOST:$DB_PORT..."

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 2
done

echo "PostgreSQL is ready!"

# Apply database migrations
python manage.py makemigrations --noinput

python manage.py migrate --noinput
echo "Migrations applied!"

# Collect static files
python manage.py collectstatic --noinput
echo "Static files collected!"

# Start Gunicorn server
exec gunicorn gymer.wsgi:application --bind 0.0.0.0:8000 --workers 3
