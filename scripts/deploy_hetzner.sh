#!/usr/bin/env bash
set -euo pipefail

# deploy_hetzner.sh
# Idempotent deploy script for deploying SuperAGI to a remote server (Hetzner or similar).
# Usage (on the remote server):
#   sudo bash deploy_hetzner.sh \
#       --repo https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git \
#       --dir /root/SuperAGI \
#       --branch main
#
# Important: I cannot SSH into your server. Copy this file to the server (scp) or
# curl it directly and run it there as root (or with sudo). The script will try to install
# Docker and the Docker Compose plugin if they're missing.

REPO_URL=""
REPO_DIR="/root/SuperAGI"
BRANCH="main"
GIT_DEPTH=1

print_usage() {
  cat <<EOF
Usage: $0 --repo REPO_URL [--dir REPO_DIR] [--branch BRANCH]

Examples:
  sudo $0 --repo https://github.com/youruser/SuperAGI.git --dir /root/SuperAGI --branch main

This script will:
  - ensure Docker is installed (using the official convenience script if needed)
  - ensure docker compose plugin is available
  - clone the repo or update an existing checkout
  - run 'docker compose down', 'docker compose up -d --build'
  - print `docker compose ps` and tail backend logs
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_URL="$2"; shift 2;;
    --dir)
      REPO_DIR="$2"; shift 2;;
    --branch)
      BRANCH="$2"; shift 2;;
    -h|--help)
      print_usage; exit 0;;
    *)
      echo "Unknown arg: $1"; print_usage; exit 1;;
  esac
done

if [ -z "$REPO_URL" ]; then
  echo "ERROR: --repo is required" >&2
  print_usage
  exit 2
fi

echo "[deploy] Repo: $REPO_URL"
echo "[deploy] Dir:  $REPO_DIR"
echo "[deploy] Branch:$BRANCH"

# must be root or have sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script expects to run as root (or with sudo)." >&2
  exit 3
fi

install_docker_if_missing() {
  if command -v docker >/dev/null 2>&1; then
    echo "[deploy] docker already installed: $(docker --version)"
  else
    echo "[deploy] docker not found — installing using official script"
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
    echo "[deploy] docker installed: $(docker --version)"
  fi

  # Ensure compose plugin is present
  if docker compose version >/dev/null 2>&1; then
    echo "[deploy] docker compose plugin available: $(docker compose version 2>/dev/null | head -n1)"
  else
    echo "[deploy] docker compose plugin not found. Attempting to install docker-compose-plugin package (Debian/Ubuntu)."
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y
      apt-get install -y docker-compose-plugin || true
    fi
    # If still not available, warn and continue (modern docker has compose builtin)
    if docker compose version >/dev/null 2>&1; then
      echo "[deploy] docker compose plugin installed."
    else
      echo "[deploy] WARNING: docker compose plugin not found after attempted install. You can still use 'docker-compose' binary if present or install the plugin manually." >&2
    fi
  fi
}

clone_or_update_repo() {
  if [ -d "$REPO_DIR/.git" ]; then
    echo "[deploy] Repo already exists at $REPO_DIR — fetching updates"
    cd "$REPO_DIR"
    git fetch --depth $GIT_DEPTH origin "$BRANCH" || git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
    git clean -fdx || true
  else
    echo "[deploy] Cloning $REPO_URL to $REPO_DIR (branch $BRANCH)"
    rm -rf "$REPO_DIR"
    git clone --depth $GIT_DEPTH --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
  fi
}

deploy_compose() {
  cd "$REPO_DIR"

  # If there's a docker compose file under a subdir (some repos keep compose in root), try root first
  if [ ! -f docker-compose.yaml ] && [ -f docker-compose.yml ]; then
    echo "[deploy] using docker-compose.yml"
  fi

  echo "[deploy] Bringing compose stack down (if running)"
  docker compose down || docker compose down --remove-orphans || true

  echo "[deploy] Pulling images (best-effort)"
  docker compose pull --ignore-pull-failures || true

  echo "[deploy] Building and starting compose stack"
  docker compose up -d --build
}

post_checks() {
  echo "[deploy] docker compose ps:"
  docker compose ps

  echo "[deploy] Tailing backend logs (service name 'backend' assumed)"
  # prefer docker compose logs if available
  if docker compose logs backend --tail 50 >/dev/null 2>&1; then
    docker compose logs backend --tail 50
  else
    echo "[deploy] docker compose logs backend not available; listing containers and showing last 50 lines for likely backend container"
    docker ps --format '{{.Names}}\t{{.Image}}' | sed -n '1,200p'
    # try to find container with name containing 'backend'
    BACKEND_CONTAINER=$(docker ps --filter "name=backend" --format "{{.Names}}" | head -n1 || true)
    if [ -n "$BACKEND_CONTAINER" ]; then
      docker logs --tail 50 "$BACKEND_CONTAINER" || true
    else
      echo "[deploy] no container named 'backend' found. Use 'docker compose ps' to find container names."
    fi
  fi
}

open_firewall_hint() {
  echo "\n[deploy] If you use UFW, consider opening these ports: 80, 443, 3000 (UI), 5432 (postgres, optional), 6379 (redis, optional)"
  echo "# Example (run as root):"
  echo "# ufw allow 80/tcp && ufw allow 443/tcp && ufw allow 3000/tcp"
}

main() {
  install_docker_if_missing
  clone_or_update_repo
  deploy_compose
  post_checks
  open_firewall_hint
  echo "[deploy] Done. If you need help inspecting logs or fixing dependency issues, run the script locally and then open an issue with logs."
}

main
