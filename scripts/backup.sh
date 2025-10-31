#!/usr/bin/env bash
# Simple backup helper for the postgresql-lab project
# Usage: ./scripts/backup.sh [output-file]
# Default output-file: ./postgres.backup

set -euo pipefail
OUT=${1:-./postgres.backup}
CONTAINER=pgsql
DB_NAME=postgres
DB_USER=${POSTGRES_USER:-admin}

echo "Creating backup inside container ($CONTAINER) ..."
docker exec -t "$CONTAINER" pg_dump -U "$DB_USER" -F c -d "$DB_NAME" -f /tmp/postgres.backup

echo "Copying backup to host: $OUT"
docker cp "$CONTAINER":/tmp/postgres.backup "$OUT"

echo "Backup saved to $OUT"
