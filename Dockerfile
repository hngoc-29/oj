# Sử dụng image Python chính thức (phiên bản phù hợp với dự án của bạn)
FROM python:3.9-slim

# Cài đặt các gói hệ thống cần thiết để build các thư viện có C extensions
RUN apt-get update && apt-get install -y \
    build-essential \
    libmysqlclient-dev \
    libxml2-dev \
    libxslt1-dev \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Sao chép file requirements.txt vào container
COPY requirements.txt .

# Nâng cấp pip và cài đặt các thư viện Python từ requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Sao chép toàn bộ mã nguồn dự án vào container
COPY . .

# Thu thập tệp tĩnh (nếu sử dụng whitenoise hoặc nếu có bước này)
RUN python manage.py collectstatic --noinput

# Mở cổng để container lắng nghe (ví dụ: cổng 8000)
EXPOSE 8000

# Khởi chạy ứng dụng sử dụng gunicorn
CMD ["gunicorn", "oj.wsgi:application", "--bind", "0.0.0.0:8000"]
