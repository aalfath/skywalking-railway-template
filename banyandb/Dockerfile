# Apache SkyWalking BanyanDB (storage for the SkyWalking OAP server), standalone mode.
# Official image, pinned by version and digest. Bump both together.
FROM apache/skywalking-banyandb:0.11.2-slim@sha256:a00d5809317a1e131f175469aa3d1e1c4f1e98db857244079861c674cc4bf60b

# All data lives under /data: mount a Railway volume there.
ENV BANYANDB_DATA_DIR=/data \
    PORT=17913

COPY --chmod=755 start.sh /railway-start.sh

EXPOSE 17912 17913
ENTRYPOINT ["/bin/sh", "/railway-start.sh"]
