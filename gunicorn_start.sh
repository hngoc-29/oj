#!/bin/bash

# Set the DJANGO_SETTINGS_MODULE environment variable
export DJANGO_SETTINGS_MODULE="dmoj.settings"

# Apply database migrations
python manage.py migrate sites --noinput
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput

# Start Gunicorn
gunicorn dmoj.wsgi:application --bind 0.0.0.0:10000
