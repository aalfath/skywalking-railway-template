[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/apache-skywalking?utm_medium=integration&utm_source=button&utm_campaign=apache-skywalking)

# Apache SkyWalking on Railway

A one-click Railway template for [Apache SkyWalking](https://skywalking.apache.org/) **11.1.0**, the open-source APM and distributed tracing system, with the storage and web UI upstream ships for it. Each part runs as its own Railway service:

| Service | What it runs | Ports | Volume |
|---|---|---|---|
| **SkyWalking** (public) | [Horizon UI](https://github.com/apache/skywalking-horizon-ui) 1.1.0, the official SkyWalking web UI, with a login | `PORT` 8081 (public domain) | none |
| **OAP** (private) | SkyWalking OAP server 11.1.0: receives agent and OpenTelemetry data, analyses it and serves the query API | 11800 gRPC (agents), 12800 HTTP (query, `/v3/*` receivers, `/healthcheck`), 17128 admin | none |
| **BanyanDB** (private) | [BanyanDB](https://github.com/apache/skywalking-banyandb) 0.11.2 standalone, SkyWalking's native storage | 17912 gRPC, 17913 HTTP (`/api/healthz`) | `/data` |

Every service builds from a folder of this repo (`banyandb/`, `oap/`, `ui/`). Each folder's `Dockerfile` starts `FROM` the official Apache image, pinned by version and digest:

- `apache/skywalking-banyandb:0.11.2-slim@sha256:a00d5809317a1e131f175469aa3d1e1c4f1e98db857244079861c674cc4bf60b`
- `apache/skywalking-oap-server:11.1.0@sha256:ddf74a9059ce4c2cc22120cb3d36b1edf6bbb0e3316eca3e4dff295dd2ff7ee9`
- `apache/skywalking-ui:horizon-1.1.0@sha256:9ff809469aa1343ce35a016079e18524ea62c580b8c1e2d719b1505e54b8c35e`

The wrappers are small: BanyanDB keeps all its storage roots on the volume, OAP binds to Railway's IPv6 private network, turns on the admin modules Horizon needs and waits for BanyanDB, and Horizon hashes a generated password into its login at boot.

## Variables

Set by the template; nothing to fill in:

- `HORIZON_ADMIN_USERNAME` (default `admin`) and `HORIZON_ADMIN_PASSWORD` (generated, 24 characters) on the **SkyWalking** service: your login. Find the password in the service's Variables tab. Change it there and redeploy to rotate it (12–64 characters).
- `HORIZON_OAP_QUERY_URL`, `HORIZON_OAP_ADMIN_URL` (SkyWalking) and `SW_STORAGE_BANYANDB_TARGETS` (OAP): private-network references between the services.
- `HORIZON_PUBLIC_URL`: the public HTTPS URL of the UI.
- `PORT` on each service: the port Railway health-checks.

Optional, not in the template (add them on the OAP service if you need them): `SW_CORE_RECORD_DATA_TTL` (traces and logs, default 3 days), `SW_CORE_METRICS_DATA_TTL` (metrics, default 7 days), `SW_AUTHENTICATION` (a token agents must send), `JAVA_OPTS` (default heap cap 2 GB). Every OAP setting is listed in its [application.yml](https://github.com/apache/skywalking/blob/v11.1.0/oap-server/server-starter/src/main/resources/application.yml).

## Sending data

Agents in your other Railway services report to OAP over the private network:

- SkyWalking agents (Java, Go, Python, Node.js and more): `SW_AGENT_COLLECTOR_BACKEND_SERVICES=oap.railway.internal:11800`
- OpenTelemetry (OTLP gRPC): `oap.railway.internal:11800`
- HTTP receivers (for example `POST /v3/segments`): `http://oap.railway.internal:12800`

If the OAP service has a different name in your project, use its `RAILWAY_PRIVATE_DOMAIN`. OAP has no public domain by default, because its receivers accept data from anyone who can reach them. To collect from outside Railway, add a TCP proxy to port 11800 on the OAP service and set `SW_AUTHENTICATION` there and in your agents.

## Updates

Railway notifies everyone who deployed this template when a change is merged to `main` here, for example a new SkyWalking version. Read [CHANGELOG.md](CHANGELOG.md) before you apply an update. BanyanDB and OAP versions must match (OAP 11.1 talks to BanyanDB 0.11), so update all three services together.

## Local test

`docker-compose.test.yml` runs the same three services (test-only password): `docker compose -f docker-compose.test.yml up -d --build`, then open http://localhost:8081 and sign in as `admin` / `local-test-password-123`.
