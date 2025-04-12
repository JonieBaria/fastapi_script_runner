FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libdrm-dev \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Set environment path
ENV PATH="/usr/bin/google-chrome:$PATH"

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Expose the FastAPI port
EXPOSE 8000

# Start FastAPI with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
