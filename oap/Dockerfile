# Apache SkyWalking OAP server (collector, analysis and query API).
# Official image, pinned by version and digest. Bump both together.
FROM apache/skywalking-oap-server:11.1.0@sha256:ddf74a9059ce4c2cc22120cb3d36b1edf6bbb0e3316eca3e4dff295dd2ff7ee9

# Railway's private network is IPv6: bind the query (12800), agent gRPC (11800)
# and admin (17128) servers on "::" (dual stack) instead of upstream's 0.0.0.0.
ENV SW_STORAGE=banyandb \
    SW_HEALTH_CHECKER=default \
    SW_TELEMETRY=prometheus \
    SW_CORE_REST_HOST=:: \
    SW_CORE_GRPC_HOST=:: \
    SW_ADMIN_SERVER_HOST=:: \
    SW_ADMIN_SERVER=default \
    SW_UI_MANAGEMENT=default \
    SW_INSPECT=default \
    SW_STATUS=default \
    SW_DSL_DEBUGGING=default \
    SW_RECEIVER_RUNTIME_RULE=default \
    JAVA_OPTS="-Xms256m -Xmx2g -Djava.net.preferIPv6Addresses=true" \
    PORT=12800

COPY --chmod=755 start.sh /skywalking/railway-start.sh

EXPOSE 11800 12800 17128
ENTRYPOINT ["bash", "/skywalking/railway-start.sh"]
