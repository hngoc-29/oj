#!/bin/bash

set -e  # Dừng script nếu có lỗi

# Cập nhật và cài gói cần thiết
apt-get update && apt-get install -y \
    git gcc g++ make python3-dev python3-pip python3-venv \
    libxml2-dev libxslt1-dev zlib1g-dev gettext \
    redis-server pkg-config supervisor nginx curl gnupg \
    default-libmysqlclient-dev nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

rm -rf vnojsite

python3 -m venv vnojsite
./vnojsite/bin/supervisord -c conf/supervisord.conf

pip install --upgrade pip setuptools wheel
# Nâng cấp pip và cài requirements
pip install -r requirements.txt

# Build frontend
npm install
chmod +x ./make_style.sh
./make_style.sh

# Collect static và dịch
python manage.py collectstatic --noinput
python manage.py compilemessages
python manage.py compilejsi18n

mkdir -p tmp

echo "🧹 Dọn dẹp file cũ..."
rm -f tmp/*.pid tmp/*.sock tmp/*.log

echo "🚀 Khởi động supervisord..."
supervisord -c conf/supervisord.conf
supervisorctl -c conf/supervisord.conf status