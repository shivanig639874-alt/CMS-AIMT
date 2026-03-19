#!/usr/bin/env bash
set -e

# Default port
PORT=${PORT:-5000}

# If DATABASE_URL or other env vars are required, ensure Render provides them.

# Use gunicorn for production
exec gunicorn --bind 0.0.0.0:${PORT} --workers 3 --threads 2 --timeout 120 "app:app"
