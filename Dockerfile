FROM python:3.11-slim

# Cài system packages
RUN apt-get update && apt-get install -y \
    git gcc g++ make python3-dev python3-pip python3-venv \
    libxml2-dev libxslt1-dev zlib1g-dev gettext curl \
    redis-server pkg-config supervisor nginx gnupg libmysqlclient-dev

# Cài Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Tạo thư mục làm việc
WORKDIR /app

# Copy toàn bộ mã nguồn vào image
COPY . /app

# Cài Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Cài Node dependencies
RUN npm install

# Build frontend styles
RUN chmod +x ./make_style.sh && ./make_style.sh

# Collect static files
RUN python manage.py collectstatic --noinput

# Compile message files
RUN python manage.py compilemessages

# Compile JS i18n (nếu cần)
RUN python manage.py compilejsi18n

# Copy các file cấu hình supervisor
COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY celery.conf /etc/supervisor/conf.d/celery.conf

# Expose các cổng cần thiết
EXPOSE 80 9996 9997 9998 9999

# Start supervisor
CMD ["/usr/bin/supervisord", "-n"]
