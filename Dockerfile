FROM python:3.12

# Không ghi bytecode và flush stdout ngay lập tức
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Tạo thư mục làm việc
WORKDIR /app

# Copy requirements và cài hệ thống + Python packages
COPY requirements.txt .

RUN apt-get update && apt-get install -y \
    gcc g++ make \
    libmariadb-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    gettext \
    curl \
    redis-server \
    pkg-config \
    python3-dev \
    python3-venv \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

# Cài Node.js v18 (LƯU Ý: bỏ sudo)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Copy toàn bộ project vào container
COPY . .

# Nếu có frontend cần build, chạy tại đây (nếu không có package.json thì comment lại dòng này)
# RUN npm install && npm run build

# Chạy uwsgi server
CMD ["uwsgi", "--http", ":10000", "--module", "dmoj.wsgi:application", "--static-map", "/static=/app/static"]
