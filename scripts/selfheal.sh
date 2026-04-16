#!/usr/bin/env bash

APP_SERVICE_NAME="app"
APP_NAME_FILTER="app"   
PROJECT_DIR="/vagrant/server"

echo "[SELFHEAL] Running self-healing check..."

# 1) Restart any unhealthy app containers
docker ps --filter "name=${APP_NAME_FILTER}" --filter "health=unhealthy" -q | while read cid; do
  if [ -n "$cid" ]; then
    echo "[SELFHEAL] Restarting unhealthy container: $cid"
    docker restart "$cid"
  fi
done

# 2) If NO app containers are running, start one via docker compose
running=$(docker ps --filter "name=${APP_NAME_FILTER}" -q | wc -l)
if [ "$running" -eq 0 ]; then
  echo "[SELFHEAL] No app containers running. Starting service via docker compose..."
  cd "$PROJECT_DIR" || exit 1
  docker compose up -d --scale ${APP_SERVICE_NAME}=1 ${APP_SERVICE_NAME}
fi
