# Image base
FROM python:3.10-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git gcc g++ make python3-dev python3-pip python3-venv \
    libxml2-dev libxslt1-dev zlib1g-dev gettext \
    redis-server pkg-config supervisor nginx curl gnupg \
    default-libmysqlclient-dev nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /app

# Copy project files
COPY . /app

# Create venv
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python packages
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Install Node dependencies & build static
RUN npm install \
    && chmod +x ./make_style.sh \
    && ./make_style.sh \
    && python manage.py collectstatic --noinput \
    && python manage.py compilemessages \
    && python manage.py compilejsi18n

# Create folders needed
RUN mkdir -p /app/static /app/media /run/nginx /var/log/supervisor

# Copy nginx & supervisor configs (assumes you put conf files in root)
COPY site.conf /etc/nginx/sites-available/site
RUN ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site

COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY celery.conf /etc/supervisor/conf.d/celery.conf

# ENV for Render
ENV PORT=10000
EXPOSE 10000

# Replace default nginx port
RUN sed -i "s/listen .*;/listen ${PORT};/" /etc/nginx/sites-available/site

# Start all via supervisord
CMD ["/usr/bin/supervisord", "-n"]
