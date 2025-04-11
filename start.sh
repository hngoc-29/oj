supervisorctl -c conf/supervisord.conf status

echo "🚀 Khởi động nginx..."
nginx -t
nginx -c /workspaces/vnoj/conf/nginx.conf -g 'daemon off;'