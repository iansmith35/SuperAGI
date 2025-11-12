#!/usr/bin/env bash
# Lightweight entrypoint for running uvicorn with expanded environment variables.
# Uses PORT env var provided by Railway, falling back to 8000 if not present.

set -eu

# Defaults
: "${PORT:=8000}"
: "${HOST:=0.0.0.0}"
: "${APP_MODULE:=main:app}"   # Change if your app module is different, e.g. superagi.app.main:app

# Ensure PORT is an integer (basic validation)
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
  echo "Invalid PORT value: '$PORT'. Falling back to 8000." >&2
  PORT=8000
fi

# Print env for debugging (temporary)
echo "STARTING with PORT='$PORT' HOST='$HOST' APP_MODULE='$APP_MODULE'" >&2

# Exec uvicorn with proxy headers enabled for proper remote address / protocol handling behind Railway's proxy
exec uvicorn "$APP_MODULE" --host "$HOST" --port "$PORT" --proxy-headers --forwarded-allow-ips="*"