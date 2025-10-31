# postgresql-lab

A small, self-contained PostgreSQL lab using Docker Compose. This repository provides a ready-to-run PostgreSQL 16 instance (with persisted data) and a pgAdmin container for quick exploration, development, and testing.

## Contents

- `docker-compose.yaml` - Compose file that defines the `db` (Postgres) and `pgadmin` services.
- `db/` - Host directory mounted into the Postgres container. Contains the live PostgreSQL data directory, configuration files and logs.

## Quick start

Prerequisites:

- Docker (>= 20.x)
- Docker Compose (v2 plugin or docker-compose)

Start the lab:

```bash
# from the repository root
docker compose up -d
```

This creates two containers:

- Postgres (container name: `pgsql`) listening on host port `5432`.
- pgAdmin (container name: `pgadmin4_container`) available at http://localhost:5050.

Default credentials (change these in `docker-compose.yaml` before using in production):

- Postgres user: `admin`
- Postgres password: `Abcd1234`
- pgAdmin email: `pgadmin@kaskade.com`
- pgAdmin password: `Abcd1234`

Connect with psql:

```bash
psql "host=localhost port=5432 user=admin password=Abcd1234 dbname=postgres"
```

Open pgAdmin in your browser: http://localhost:5050 and add a server using the Postgres host/port and credentials above.

## Data and configuration

The Compose file mounts `./db/data` to `/var/lib/postgresql/data` in the container. That folder contains the PostgreSQL cluster files and configuration files (for example `postgresql.conf`, `pg_hba.conf`) so changes persist across container restarts.

Logs are mounted from `./db/logs` and the Compose command enables the logging collector to write logs there.

If you want to inspect or edit Postgres configuration, edit the files under `db/` (for instance `db/postgresql.conf` or `db/pg_hba.conf`) and then restart the container:

```bash
docker compose restart db
```

## Resetting the database

To remove the containers and the persistent data (destructive):

```bash
docker compose down
# then remove data directory on host
rm -rf db/data/*
```

Or remove volumes created by Compose (if used):

```bash
docker compose down -v
```

## Backup & restore

Backup a database with `pg_dump` from the host:

```bash
docker exec -t pgsql pg_dump -U admin -F c -d postgres -f /tmp/postgres.backup
docker cp pgsql:/tmp/postgres.backup ./postgres.backup
```

Restore from a dump:

```bash
docker cp ./postgres.backup pgsql:/tmp/postgres.backup
docker exec -it pgsql pg_restore -U admin -d postgres /tmp/postgres.backup
```

Adjust `pg_dump`/`pg_restore` arguments to suit your backup format and needs.

## Security notes

- The default credentials in `docker-compose.yaml` are intentionally simple for lab use. Never use these in production.
- Prefer providing credentials through environment variables or a secrets manager instead of committing them to source control.

## Troubleshooting

- If the Postgres container fails to start, check `db/logs` and the container logs:

	```bash
	docker logs pgsql
	tail -n 200 db/logs/postgresql-*.log || true
	```

- If you see permission errors on `db/data`, ensure the host directory is writable by your Docker daemon user.

## Contributing

Small improvements welcome: open issues and PRs. For configuration or seed data changes, add a short description of the intent and any migration steps.

## License

This repository is provided under the terms of the LICENSE file in the repository root.

---
Last updated: Oct 31, 2025