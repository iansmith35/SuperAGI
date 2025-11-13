#!/usr/bin/env bash
set -euo pipefail

# railway_release.sh
# Intended to be run during Railway's release phase (before web process starts).
# It runs DB migrations and any one-time initialization (creating default agent).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[railway_release] Activating virtualenv if present"
if [ -d venv ]; then
  # shellcheck disable=SC1090
  source venv/bin/activate
fi

echo "[railway_release] Running alembic migrations (if alembic.ini exists) using Python runner"
if [ -f alembic.ini ]; then
  echo "[railway_release] Generating .env.generated from Railway env vars (if present)"
  if command -v python3 >/dev/null 2>&1 && [ -f scripts/railway_env_mapper.py ]; then
    python3 scripts/railway_env_mapper.py || true
  fi
  if command -v python3 >/dev/null 2>&1; then
    python3 scripts/run_migrations.py || true
  else
    echo "[railway_release] python3 not found — skipping migrations"
  fi
else
  echo "[railway_release] alembic.ini missing — skipping migrations"
fi

echo "[railway_release] Initializing default agent (if code available)"
if [ -f scripts/initialize_agent.py ]; then
  python3 scripts/initialize_agent.py || true
else
  echo "[railway_release] scripts/initialize_agent.py not found — skipping"
fi

echo "[railway_release] Initializing ISHE Group CRM agents"
if [ -f scripts/initialize_crm_agents.py ]; then
  python3 scripts/initialize_crm_agents.py || true
else
  echo "[railway_release] scripts/initialize_crm_agents.py not found — skipping"
fi

echo "[railway_release] Release tasks completed"
