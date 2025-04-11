
echo "🚀 Khởi động supervisord..."
./vnojsite/bin/supervisord -c conf/supervisord.conf
./vnojsite/bin/supervisorctl -c conf/supervisord.conf s
echo "🚀 Khởi động nginx..."
nginx -t
nginx -c /workspaces/vnoj/conf/nginx.conf -g 'daemon off;'
