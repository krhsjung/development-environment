#!/bin/bash
# init.sh - MariaDB 초기화 스크립트 (환경변수 사용)

echo "🏗 Running custom MariaDB-slave initialization script..."

# root 비밀번호는 docker-compose 환경변수로 전달됨
mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" << EOF

  CHANGE MASTER TO
    MASTER_HOST='mariadb-master',
    MASTER_USER='${MARIADB_REPLICATION_USER}',
    MASTER_PASSWORD='${MARIADB_REPLICATION_PASSWORD}',
    MASTER_PORT=${MARIADB_MASTER_PORT};

  START SLAVE;
  SHOW SLAVE STATUS\G

EOF

echo "✅ Initialization complete."
