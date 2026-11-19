# Apache SkyWalking Horizon UI (the official SkyWalking web UI since OAP 10.5 / 11).
# Official image, pinned by version and digest. Bump both together.
FROM apache/skywalking-ui:horizon-1.1.0@sha256:9ff809469aa1343ce35a016079e18524ea62c580b8c1e2d719b1505e54b8c35e

# Listen on Railway's PORT; cookies only over HTTPS (Railway domains are HTTPS).
ENV HORIZON_SERVER_HOST=:: \
    HORIZON_SESSION_COOKIE_SECURE=true \
    PORT=8081

# Start wrapper: turns HORIZON_ADMIN_PASSWORD into an Argon2id login, then starts Horizon.
COPY railway-start.mjs /app/railway-start.mjs

EXPOSE 8081
CMD ["node", "/app/railway-start.mjs"]
