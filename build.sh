#!/bin/bash

set -e
apt-get update && apt-get install -y \
    git gcc g++ make python3-dev python3-pip python3-venv \
    libxml2-dev libxslt1-dev zlib1g-dev gettext \
    redis-server pkg-config supervisor nginx curl gnupg \
    default-libmysqlclient-dev nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
echo "🌱 Tạo Python virtualenv..."
rm -rf vnojsite
python3 -m venv vnojsite
source vnojsite/bin/activate

echo "📦 Cài đặt supervisor và các Python dependency..."
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
pip install supervisor

echo "🧱 Cài đặt Node.js dependencies..."
npm install
chmod +x ./make_style.sh
./make_style.sh

echo "🧹 Dọn dẹp file cũ..."
mkdir -p tmp
rm -f tmp/*.pid tmp/*.sock tmp/*.log

echo "🛠️ Collect static và dịch messages..."
python manage.py collectstatic --noinput
python manage.py compilemessages
python manage.py compilejsi18n
