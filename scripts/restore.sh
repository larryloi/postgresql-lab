#!/usr/bin/env bash
# Simple restore helper for the postgresql-lab project
# Usage: ./scripts/restore.sh <backup-file>

set -euo pipefail
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <backup-file>"
  exit 2
fi
INFILE=$1
CONTAINER=pgsql
DB_NAME=postgres
DB_USER=${POSTGRES_USER:-admin}

if [ ! -f "$INFILE" ]; then
  echo "Backup file not found: $INFILE"
  exit 3
fi

echo "Copying $INFILE to container $CONTAINER:/tmp/postgres.backup ..."
docker cp "$INFILE" "$CONTAINER":/tmp/postgres.backup

echo "Restoring into database $DB_NAME ..."
docker exec -it "$CONTAINER" pg_restore -U "$DB_USER" -d "$DB_NAME" /tmp/postgres.backup

echo "Restore complete"
