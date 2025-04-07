#!/bin/bash

# Set the DJANGO_SETTINGS_MODULE environment variable
export DJANGO_SETTINGS_MODULE="dmoj.settings"

# Start Gunicorn
gunicorn dmoj.wsgi:application --bind 0.0.0.0:10000
