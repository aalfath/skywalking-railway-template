#!/bin/sh
# Start BanyanDB standalone with every storage root on the volume.
# gRPC (17912) is what the OAP server uses; HTTP ($PORT, default 17913) serves /api/healthz.
set -e
D="${BANYANDB_DATA_DIR:-/data}"
mkdir -p "$D/measure" "$D/stream" "$D/trace" "$D/property" "$D/schema"
exec /banyand standalone \
  --grpc-port=17912 \
  --http-port="${PORT:-17913}" \
  --measure-root-path="$D/measure" \
  --stream-root-path="$D/stream" \
  --trace-root-path="$D/trace" \
  --property-root-path="$D/property" \
  --schema-server-root-path="$D/schema" \
  "$@"
