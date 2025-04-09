FROM python:3.12

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy trước để tận dụng cache Docker layer
COPY requirements.txt .

# Cài hệ thống dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ make \
    git \
    libmariadb-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    pkg-config \
    gettext \
    curl \
    redis-server \
    python3-dev \
    python3-venv \
    ca-certificates \
    gnupg \
    nginx \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

# Cài Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Copy toàn bộ project
COPY . .

# Copy cấu hình nginx và uwsgi
COPY nginx/oj.conf /etc/nginx/conf.d/default.conf
COPY uwsgi.ini /app/uwsgi.ini

# Ngăn nginx chạy dưới dạng daemon (foreground)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# CMD chạy cả nginx + uwsgi
CMD ["sh", "-c", "service nginx start && uwsgi --ini /app/uwsgi.ini"]
