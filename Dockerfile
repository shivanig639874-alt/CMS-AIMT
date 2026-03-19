FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Copy only what's needed from the app subfolder
# Use JSON array form for COPY to handle paths with spaces
COPY ["SIM AIMT/Programs/SIM AIMT/requirements.txt", "requirements.txt"]
# Ensure pip, setuptools and wheel are up-to-date so pkg_resources is available
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code into /app
COPY ["SIM AIMT/Programs/SIM AIMT", "/app"]

# Ensure start script is executable
RUN chmod +x /app/start.sh

EXPOSE 5000
ENV PORT 5000

CMD ["/app/start.sh"]
