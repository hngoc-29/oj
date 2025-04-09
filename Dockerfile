FROM python:3.12

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN apt update && apt install -y gcc python3-dev libmariadb-dev \
    && pip install -r requirements.txt && npm i

COPY . .

CMD ["uwsgi", "--http", ":10000", "--module", "dmoj.wsgi:application", "--static-map", "/static=/app/static"]
