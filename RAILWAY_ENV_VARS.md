Railway environment variables and recommended mappings for SuperAGI
===============================================================

This document lists the environment variables SuperAGI expects, recommended values, and which Railway plugins supply them.

Core runtime / server
- HOST: 0.0.0.0  # Not required on Railway; uvicorn uses $PORT
- PORT: Railway automatically provides $PORT at runtime. Do NOT hardcode.
- ENVIRONMENT: production

Database (Postgres)
- DATABASE_URL or DB_URL: PostgreSQL connection string. Example format:
  postgres://user:password@host:5432/dbname
  - Railway Postgres plugin provides `DATABASE_URL` in this format.
  - The app's `main.py` first checks `DB_URL`, then builds connection from DB_HOST/DB_USERNAME/DB_PASSWORD/DB_NAME.
  Recommendation: set `DB_URL` or `DATABASE_URL` to Railway's provided value.

Alternative DB variables (if you prefer separate parts)
- DB_HOST
- DB_USERNAME
- DB_PASSWORD
- DB_NAME

Redis
- REDIS_URL or REDIS_HOST/REDIS_PORT
  - Railway Redis plugin provides a connection string (eg: `redis://:<password>@host:6379`). Map it to `REDIS_URL`.

JWT / security
- JWT_SECRET_KEY: a strong secret for signing JWTs (generate a random 32+ char value)

API keys & Integrations (example keys; set as needed)
- OPENAI_API_KEY
- GOOGLE_API_KEY
- GEMINI_API_KEY
- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET
- GOOGLE_REFRESH_TOKEN
- SUPABASE_URL
- SUPABASE_KEY

Optional behaviour toggles
- ENABLE_CHATBOT=True
- ENABLE_SPEECH=True
- ENABLE_GOOGLE_CONNECTORS=True
- ENABLE_SUPABASE_MEMORY=True
- FRONTEND_URL: URL of your frontend (e.g., https://your-app.onrailway.app)

Notes & recommendations
- Use Railway's Plugin UI to provision Postgres and Redis; add the produced connection variables into the Environment variables page.
- Prefer `DATABASE_URL` for simplicity — `main.py` will accept a DB_URL but can also read DB_HOST/DB_USERNAME where needed.
- Keep secrets out of the repo. Use Railway's Environment variables (Secrets) UI.
- If using the non-Docker path on Railway, ensure system-level build deps aren't required at runtime; if pip fails, prefer Docker deploy.

Minimal set for a working deployment (example):

DATABASE_URL=postgres://superagi:password@<HOST>:5432/super_agi_main
REDIS_URL=redis://:<password>@<HOST>:6379
JWT_SECRET_KEY=some-very-strong-secret
ENVIRONMENT=production
FRONTEND_URL=https://your-frontend.example.com

If you want, I can produce a script that maps Railway plugin env names to the exact variables expected by the app (for example, auto-set DB_URL from Railway's DATABASE_URL). Ask and I'll add it.
