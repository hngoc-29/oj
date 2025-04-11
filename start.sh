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
echo "🧩 Trạng thái services:"
./vnojsite/bin/supervisorctl -c conf/supervisord.conf status
echo "Render is using PORT=$PORT"

# echo "🚀 Khởi động nginx..."
# /usr/sbin/nginx -t
# /usr/sbin/nginx -c /workspaces/vnoj/conf/nginx.conf -g 'daemon off;'

