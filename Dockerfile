FROM python:3.11-slim

# Install system dependencies including amass
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install amass from GitHub releases
RUN wget -q https://github.com/owasp-amass/amass/releases/download/v4.2.0/amass_Linux_amd64.zip -O /tmp/amass.zip \
    && unzip /tmp/amass.zip -d /tmp/amass \
    && mv /tmp/amass/amass_Linux_amd64/amass /usr/local/bin/amass \
    && chmod +x /usr/local/bin/amass \
    && rm -rf /tmp/amass /tmp/amass.zip

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Set environment variables
ENV HOST=0.0.0.0
ENV PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 8000

# Run the server
CMD ["python", "server.py"]
