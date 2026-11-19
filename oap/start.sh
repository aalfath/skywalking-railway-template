#!/bin/bash
# Wait for BanyanDB, then hand over to the upstream entrypoint.
set -e
export SW_CORE_REST_PORT="${PORT:-12800}"
TARGET="${SW_STORAGE_BANYANDB_TARGETS:-127.0.0.1:17912}"
HOST="${TARGET%:*}"; PORTNUM="${TARGET##*:}"
HOST="${HOST#[}"; HOST="${HOST%]}"
echo "[railway] waiting for BanyanDB at ${HOST}:${PORTNUM}"
for i in $(seq 1 120); do
  if (exec 3<>"/dev/tcp/${HOST}/${PORTNUM}") 2>/dev/null; then
    echo "[railway] BanyanDB is reachable"; break
  fi
  sleep 2
done
cd /skywalking
exec bash docker-entrypoint.sh "$@"
