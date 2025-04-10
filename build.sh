python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
npm install
./make_style.sh
python manage.py collectstatic --noinput