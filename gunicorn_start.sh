#!/bin/bash

# Set the DJANGO_SETTINGS_MODULE environment variable
export DJANGO_SETTINGS_MODULE="dmoj.settings"

# Collect static files before starting Gunicorn
python manage.py collectstatic --noinput

# Start Gunicorn
gunicorn dmoj.wsgi:application --bind 0.0.0.0:10000
