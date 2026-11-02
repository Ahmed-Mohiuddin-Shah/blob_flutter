#!/usr/bin/env bash
# Mirror MEASURE_* from root .env into ios/Flutter/{Dev,Prod}.xcconfig
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env"

val() {
  local key="$1"
  grep -E "^${key}=" "$ENV_FILE" | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'"
}

write_xc() {
  local flavor="$1" # Dev|Prod
  local prefix="$2" # DEV|PROD
  local out="$ROOT/ios/Flutter/${flavor}.xcconfig"
  local url key
  url="$(val "${prefix}_MEASURE_API_URL")"
  key="$(val "${prefix}_MEASURE_API_KEY_IOS")"
  cat >"$out" <<EOF
#include "Generated.xcconfig"

// Synced from .env by tool/sync_measure_ios_env.sh — self-hosted measure.sh
MEASURE_API_URL=${url}
MEASURE_API_KEY=${key}
EOF
  echo "wrote $out"
}

write_xc Dev DEV
write_xc Prod PROD
