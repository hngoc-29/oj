import os
from django.core.wsgi import get_wsgi_application

# Đảm bảo DJANGO_SETTINGS_MODULE được cấu hình đúng
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'dmoj.settings')

application = get_wsgi_application()
