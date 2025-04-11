#!/bin/bash
set -e

# Kích hoạt virtualenv
source ./vnojsite/bin/activate

echo "🧹 Dọn dẹp file cũ..."
mkdir -p tmp
rm -f tmp/*.pid tmp/*.sock tmp/*.log

echo "🚀 Khởi động supervisord..."
supervisord -c conf/supervisord.conf

# Không chạy nginx, Render sẽ gọi PORT trực tiếp tới uWSGI (qua uwsgi.ini)
