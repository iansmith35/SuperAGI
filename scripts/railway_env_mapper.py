#!/usr/bin/env python3
"""Generate a .env.generated file from Railway-provided environment variables.

This script helps map common Railway plugin variables into the app's expected variables.
It does not overwrite an existing .env file. Instead, it writes .env.generated to show
the mapping (you can copy it into .env or use it in CI).

Usage:
  python3 scripts/railway_env_mapper.py
"""
import os
from urllib.parse import urlparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / '.env.generated'

def parse_database_url(db_url):
    parts = urlparse(db_url)
    user = None
    password = None
    if parts.username:
        user = parts.username
    if parts.password:
        password = parts.password
    host = parts.hostname
    port = parts.port
    dbname = parts.path.lstrip('/') if parts.path else ''
    return user, password, host, port, dbname

def main():
    env = {}
    # Primary DB URL (Railway provides DATABASE_URL)
    db_url = os.getenv('DATABASE_URL') or os.getenv('DB_URL')
    if db_url:
        env['DB_URL'] = db_url
        user, password, host, port, dbname = parse_database_url(db_url)
        if user: env['DB_USERNAME'] = user
        if password: env['DB_PASSWORD'] = password
        if host: env['DB_HOST'] = host
        if port: env['DB_PORT'] = str(port)
        if dbname: env['DB_NAME'] = dbname

    # Redis
    redis_url = os.getenv('REDIS_URL') or os.getenv('REDIS_URI') or os.getenv('REDIS')
    if redis_url:
        env['REDIS_URL'] = redis_url
        p = urlparse(redis_url)
        if p.hostname: env['REDIS_HOST'] = p.hostname
        if p.port: env['REDIS_PORT'] = str(p.port)

    # Other commonly used variables — copy if present
    for key in ['JWT_SECRET_KEY','OPENAI_API_KEY','GOOGLE_API_KEY','SUPABASE_URL','SUPABASE_KEY','FRONTEND_URL','ENVIRONMENT']:
        val = os.getenv(key)
        if val:
            env[key] = val

    if not env:
        print('[env-mapper] No relevant Railway env vars detected. Exiting.')
        return

    if (ROOT / '.env').exists():
        print('[env-mapper] .env already exists — not overwriting. Generated file will be .env.generated')

    with OUT.open('w') as f:
        for k, v in env.items():
            f.write(f"{k}={v}\n")

    print(f"[env-mapper] Wrote {OUT}. Review and copy to .env if desired.")

if __name__ == '__main__':
    main()
