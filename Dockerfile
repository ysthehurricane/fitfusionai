FROM python:3.10-slim

WORKDIR /app

# Install PostgreSQL client and system deps
RUN apt-get update && apt-get install -y postgresql-client build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn
RUN ln -s /root/.local/bin/gunicorn /usr/local/bin/gunicorn || true

# Copy app files
COPY . .

# Add entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Set environment variables
ENV DJANGO_SETTINGS_MODULE=gymer.settings \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Run entrypoint
ENTRYPOINT ["./entrypoint.sh"]
