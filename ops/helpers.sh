#!/usr/bin/env bash
set -euo pipefail

# Defaults from conventions
: "${NODE_IP:=192.168.29.50}"  # export NODE_IP to override when needed

log(){ printf "\n\033[1;36m==> %s\033[0m\n" "$*"; }

need(){ command -v "$1" >/dev/null 2>&1 || { echo "missing: $1"; exit 1; }; }

expect_http_ok(){
  local url="$1" ; local tries=60 ; local delay=2
  need curl
  for i in $(seq 1 "$tries"); do
    code=$(curl -s -o /dev/null -w '%{http_code}' "$url" || true)
    if [[ "$code" =~ ^(200|301|302)$ ]]; then
      log "HTTP OK $code for $url"
      return 0
    fi
    sleep "$delay"
  done
  echo "timeout waiting for $url" >&2
  exit 1
}

compose_up(){
  local stack_dir="$1"; shift || true
  need docker
  pushd "$stack_dir" >/dev/null
  if [[ -f ports.override.yml ]]; then
    docker compose -f docker-compose.yml -f ports.override.yml up -d "$@"
  else
    docker compose -f docker-compose.yml up -d "$@"
  fi
  popd >/dev/null
}
