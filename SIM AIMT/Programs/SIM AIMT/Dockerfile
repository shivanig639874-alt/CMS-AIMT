FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install runtime dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 5000
ENV PORT 5000

CMD ["/app/start.sh"]
