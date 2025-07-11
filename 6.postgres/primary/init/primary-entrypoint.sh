#!/bin/bash
# init.sh - PostgreSQL primary 초기화 스크립트 (환경변수 사용)
set -e

echo ">> initializing PostgreSQL primary server"

# psql 클라이언트 옵션
PSQL="psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER"

echo "  >> creating replication role: $POSTGRES_REPLICATION_USER"
$PSQL <<-EOSQL
  CREATE ROLE ${POSTGRES_REPLICATION_USER} WITH REPLICATION LOGIN PASSWORD '${POSTGRES_REPLICATION_PASSWORD}';
  SELECT pg_create_physical_replication_slot('$POSTGRES_REPLICATION_SLOT');
EOSQL

echo ">> replication slot '$POSTGRES_REPLICATION_SLOT' created"