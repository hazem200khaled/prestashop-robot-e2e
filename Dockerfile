FROM python:3.12-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl tzdata ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Workdir
WORKDIR /project

# Default command - can be overridden by docker-compose
CMD ["robot", "-d", "results", "tests"]