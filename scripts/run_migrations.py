#!/usr/bin/env python3
"""Run alembic migrations programmatically without relying on the alembic CLI binary.

This script will:
- load alembic.ini from the repo root
- override sqlalchemy.url from DATABASE_URL or DB_URL env var if present
- run 'upgrade head'

Usage:
  python3 scripts/run_migrations.py
"""
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ALEMBIC_INI = ROOT / "alembic.ini"

def run_alembic():
    if not ALEMBIC_INI.exists():
        print(f"[migrations] alembic.ini not found at {ALEMBIC_INI}, skipping migrations.")
        return 0

    try:
        from alembic.config import Config
        from alembic import command
    except Exception as e:
        print("[migrations] Alembic is not installed in the environment. Install alembic or run migrations in Docker.")
        print(f"[migrations] error: {e}")
        return 2

    cfg = Config(str(ALEMBIC_INI))

    # allow runtime override of DB URL
    db_url = os.getenv("DATABASE_URL") or os.getenv("DB_URL")
    if db_url:
        cfg.set_main_option("sqlalchemy.url", db_url)
        print("[migrations] Overriding sqlalchemy.url from env var.")

    try:
        print("[migrations] Running alembic upgrade head...")
        command.upgrade(cfg, "head")
        print("[migrations] Alembic migrations applied successfully.")
        return 0
    except Exception as e:
        print(f"[migrations] Alembic upgrade failed: {e}")
        return 3

if __name__ == '__main__':
    sys.exit(run_alembic())
