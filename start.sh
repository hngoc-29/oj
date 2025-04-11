sudo supervisorctl -c conf/supervisord.conf status

echo "🚀 Khởi động nginx..."
sudo nginx -t
sudo nginx -c /workspaces/vnoj/conf/nginx.conf -g 'daemon off;'