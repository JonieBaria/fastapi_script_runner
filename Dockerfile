# Use official Python image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy project files to the container
COPY . /app

# Upgrade pip and install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Expose the port uvicorn will run on
EXPOSE 8000

# Command to run your FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
