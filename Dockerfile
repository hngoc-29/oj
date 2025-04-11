# Base image
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git gcc g++ make python3-dev python3-pip python3-venv \
    libxml2-dev libxslt1-dev zlib1g-dev gettext \
    redis-server pkg-config supervisor nginx curl gnupg \
    default-libmysqlclient-dev nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Create and activate virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Build frontend assets and collect static files
RUN npm install \
    && chmod +x ./make_style.sh \
    && ./make_style.sh \
    && python manage.py collectstatic --noinput \
    && python manage.py compilemessages \
    && python manage.py compilejsi18n

# Create necessary directories
RUN mkdir -p /app/static /app/media /run/nginx /var/log/supervisor

# Copy Nginx config
COPY app/nginx/default.conf /etc/nginx/sites-available/site
RUN ln -sf /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site

# Test Nginx config
RUN nginx -t

# Copy Supervisor configs
COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY celery.conf /etc/supervisor/conf.d/celery.conf

# Expose port for Render
ENV PORT=10000
EXPOSE 10000

# Replace default listen port in Nginx config (optional if already set in file)
RUN sed -i "s/listen .*;/listen ${PORT};/" /etc/nginx/sites-available/site || true

# Start supervisor
CMD ["/usr/bin/supervisord", "-n"]
