#!/bin/bash
set -e

echo "=== Restoring Nookipedia Database from Dump ==="
pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" -1 --clean --if-exists -O -c /docker-entrypoint-initdb.d/data.dump
echo "=== Restore Complete! ==="
