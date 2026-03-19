AIMT — Deploy to Render
=======================

This document describes how to deploy the AIMT Flask app to Render using the included `Dockerfile` and `render.yaml`.

Prerequisites
- Render account
- GitHub account with this repository pushed: https://github.com/shivanig639874-alt/CMS-AIMT.git
- Optional: `render` CLI if you prefer command-line operations

Quick summary
- The repository root already contains a `Dockerfile`, `start.sh`, `.dockerignore` and `render.yaml`.
- The app runs on port `5000` and is started with Gunicorn (`app:app`).

Push (if not already pushed)
```bash
cd "SIM AIMT/Programs/SIM AIMT"
git remote add origin https://github.com/shivanig639874-alt/CMS-AIMT.git
git branch -M main
git push -u origin main
```

Render Dashboard: step-by-step
1. Sign in to Render and click **New → Web Service**.
2. Connect your Git provider (GitHub) and select repository `shivanig639874-alt/CMS-AIMT` and branch `main`.
3. Repository Root / Root Directory:
   - If the repo root is the app folder, leave as `.`.
   - If the app is inside a subfolder, set Root Directory to `SIM AIMT/Programs/SIM AIMT`.
4. Environment: choose **Docker**.
5. Name: choose `aimt-web` (or any name).
6. Plan: choose **Free**.
7. Dockerfile Path: `Dockerfile` (or `SIM AIMT/Programs/SIM AIMT/Dockerfile` when using a subfolder).
8. Build Command: leave blank (Docker will build from Dockerfile).
9. Start Command: leave blank (Docker CMD `/app/start.sh` will be used) or set explicitly to:
   - `./start.sh`
   - or `gunicorn --bind 0.0.0.0:$PORT "app:app"`
10. Environment Variables (add under Service → Environment):
    - `SECRET_KEY` = (generate a strong random string)
    - `FLASK_ENV` = `production`
    - `PORT` = `5000` (Render sets `PORT` automatically; this is optional)
    - If using a managed DB: set `SQLALCHEMY_DATABASE_URI` (or `DATABASE_URL`) to the connection string.
    - Any SMTP or external service keys your app requires.
11. (Optional) Add a Render PostgreSQL database: Dashboard → New → PostgreSQL. Then copy the connection string into `SQLALCHEMY_DATABASE_URI`.
12. Click **Create Web Service** and watch the build logs.

Database and migrations
- By default the app uses SQLite (`sqlite:///aimt_college.db`). This file inside the container is ephemeral — use PostgreSQL for production.
- To run migrations locally:
```bash
cd "SIM AIMT/Programs/SIM AIMT"
export FLASK_APP=app.py
flask db upgrade
```
- To run migrations on Render after deploy: open the service, select **Shell** (a one-off shell), then run the same commands (export `FLASK_APP=app.py` may be required).

Persistent storage and uploads
- Render containers have ephemeral storage. For uploaded files store them in S3 or other object storage and keep only references in the DB.

Health checks and logging
- Optionally configure a health check path (e.g., `/`) in the service settings.
- Use the Render Logs tab to inspect stdout/stderr from Gunicorn and the app.

Troubleshooting
- If the build fails with missing packages, confirm `requirements.txt` is accurate and includes `gunicorn`.
- If the app shows database errors, ensure `SQLALCHEMY_DATABASE_URI` is set to a valid DB and migrations have been applied.

Security notes
- Never store secrets in the repository. Use Render's environment variables for `SECRET_KEY`, DB passwords, and SMTP credentials.

Optional: make `start.sh` run migrations automatically
- If you want to run migrations before Gunicorn starts, modify `start.sh` to run `flask db upgrade` (ensure `FLASK_APP` is set).

Contact
- If you want, I can:
  - run a local Docker build and smoke-test the image (requires Docker locally),
  - modify `start.sh` to auto-run migrations, or
  - create a Render Postgres instance and add the `SQLALCHEMY_DATABASE_URI` env var in the repo's `render.yaml`.
