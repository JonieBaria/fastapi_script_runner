FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    unzip \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libdrm-dev \
    libgbm1 \
    ca-certificates

# Add Google Chrome GPG key and repo
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list

# Install Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Set environment variable for Chrome
ENV CHROME_BIN=/usr/bin/google-chrome

# Set working directory
WORKDIR /app

# Copy source code
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expose FastAPI port
EXPOSE 8000

# Run FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
