#!/bin/bash
# init.sh - MariaDB 초기화 스크립트 (환경변수 사용)

echo "🏗 Running custom MariaDB-master initialization script..."

# root 비밀번호는 docker-compose 환경변수로 전달됨
mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" << EOF

  CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
  GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MARIADB_USER}'@'%';
  
  FLUSH PRIVILEGES;

EOF

echo "✅ Initialization complete."
