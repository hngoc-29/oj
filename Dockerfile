# Use a Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies for packages that require compilation
RUN apt-get update && apt-get install -y \
    build-essential \
    libmysqlclient-dev \
    libxml2-dev \
    libxslt1-dev \
    python3-dev

# Upgrade pip and install the dependencies
RUN pip install --upgrade pip setuptools wheel && pip install -r requirements.txt

# Copy the application code
COPY . /app

# Set the entry point
CMD ["python", "app.py"]
