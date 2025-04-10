#!/bin/bash

# Export env nếu cần
export DJANGO_SETTINGS_MODULE=dmoj.settings

# Start nginx
nginx

# Start uWSGI
/home/n/oj/venv/bin/uwsgi --ini /home/n/oj/uwsgi.ini &

# Start bridged
/home/n/oj/venv/bin/python /home/n/oj/manage.py runbridged &

# Start Celery worker
/home/n/oj/venv/bin/celery -A dmoj_celery worker &

# Wait để giữ container sống
wait
