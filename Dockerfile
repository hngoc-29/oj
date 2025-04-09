# Stage 1: Build Python environment
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    gcc g++ make \
    libmariadb-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    gettext \
    nginx \
    uwsgi \
    uwsgi-plugin-python3 \
    curl \
    python3-dev \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy app code
COPY . .

# Copy nginx config
COPY nginx/oj.conf /etc/nginx/conf.d/default.conf

# Copy uwsgi config
COPY uwsgi.ini /app/uwsgi.ini

# Run both nginx + uwsgi
CMD service nginx start && uwsgi --ini /app/uwsgi.ini
