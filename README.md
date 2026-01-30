# Development Environment

Docker 및 Kubernetes 기반의 로컬 개발 인프라 환경 구성 모음입니다. 컨테이너 오케스트레이션, 데이터베이스 복제, 로깅/모니터링, 캐싱, 컨테이너 레지스트리 등 다양한 인프라 컴포넌트를 Docker Compose와 Kubernetes 매니페스트로 관리합니다.

## 구성 요소

| #   | 컴포넌트                              | 기술 스택                                         | 설명                                                  |
| --- | ------------------------------------- | ------------------------------------------------- | ----------------------------------------------------- |
| 1   | [Kind](1.kind/)                       | Kind, Docker, CoreDNS                             | 로컬 Kubernetes 클러스터 (Control Plane + Worker 3대) |
| 2   | [Dashboard](2.dashboard/)             | Kubernetes Dashboard v2.7.0                       | Kubernetes 클러스터 웹 UI (Admin/Read-only RBAC)      |
| 3   | [Elastic Stack](3.elastic-stack/)     | Elasticsearch, Kibana, Logstash, Filebeat v8.18.0 | 중앙 집중식 로깅 및 모니터링 (Nginx 로그 파이프라인)  |
| 4   | [Docker Registry](4.docker-registry/) | Docker Registry v2, Registry UI                   | 프라이빗 Docker 이미지 레지스트리                     |
| 5   | [MariaDB](5.mariadb/)                 | MariaDB 11.4.2                                    | Master-Slave 바이너리 로그 복제 (1 Master + 2 Slave)  |
| 6   | [PostgreSQL](6.postgres/)             | PostgreSQL 17.5                                   | Primary-Standby 스트리밍 복제 (WAL 기반)              |
| 7   | [Redis](7.redis/)                     | Redis 8.2                                         | 인메모리 캐시 및 세션 스토어                          |

## 사전 요구사항

- Docker & Docker Compose
- kubectl (Kubernetes 컴포넌트 사용 시)
- Kind (로컬 Kubernetes 클러스터 사용 시)

## 사용법

각 컴포넌트 디렉토리에서 Docker Compose로 실행합니다.

```bash
# 예시: Elastic Stack 실행
cd 3.elastic-stack
docker compose up -d

# 예시: PostgreSQL 복제 환경 실행
cd 6.postgres
docker compose up -d

# 예시: Kind 클러스터 생성
cd 1.kind
./create-cluster.sh
```

환경 변수는 각 디렉토리의 `.env` 파일에서 설정합니다. 비밀번호 등 민감한 값은 환경 변수를 통해 외부에서 주입합니다.

## 디렉토리 구조

```
.
├── 1.kind/                    # Kind Kubernetes 클러스터
│   ├── create-cluster.sh
│   ├── kind-config.yaml
│   └── kind-config-full-port-range.yaml
├── 2.dashboard/               # Kubernetes Dashboard
│   ├── 1.recommended.v2.7.0.yaml
│   ├── 2.service.yaml
│   ├── 3~8. RBAC 및 인증 매니페스트
├── 3.elastic-stack/           # ELK Stack
│   ├── docker-compose.yml
│   ├── elasticsearch/
│   ├── kibana/
│   ├── logstash/
│   └─── filebeat/
│
├── 4.docker-registry/         # Private Docker Registry
│   └── docker-compose.yml
├── 5.mariadb/                 # MariaDB 복제
│   ├── docker-compose.yml
│   ├── master-init/
│   └── slave-init/
├── 6.postgres/                # PostgreSQL 복제
│   ├── docker-compose.yml
│   ├── primary/
│   ├── standby/
│   └── config.d/
└─── 7.redis/                   # Redis
    ├── docker-compose.yml
    └── redis.conf
```

## 주요 특징

### 데이터베이스 복제

- **MariaDB**: ROW 기반 바이너리 로그 복제, 7일 binlog 보관, 동기식 binlog
- **PostgreSQL**: WAL 스트리밍 복제, 물리적 복제 슬롯, 애플리케이션별 사용자 권한 분리 (NestJS, Spring Boot)

### 보안

- Elastic Stack: X-Pack Security, TLS/SSL 인증서 자동 생성
- Docker Registry: htpasswd 인증
- Kubernetes Dashboard: RBAC (Admin / Read-only)
- 모든 데이터베이스: 패스워드 인증 및 환경 변수 기반 시크릿 관리

### 로깅 파이프라인

- Filebeat (로그 수집) → Logstash (파싱/변환) → Elasticsearch (저장) → Kibana (시각화)
- Nginx access/error 로그 자동 파싱 및 일별 인덱스 관리

### 네트워크

- 각 서비스별 격리된 Docker 네트워크
- Kind 클러스터의 `host.docker.internal` DNS 자동 설정 (Pod에서 호스트 접근)

## 포트 매핑

| 서비스             | 기본 포트 |
| ------------------ | --------- |
| Elasticsearch      | 9200      |
| Kibana             | 5601      |
| Logstash (Beats)   | 5044      |
| Docker Registry    | 5000      |
| Docker Registry UI | 5001      |
| MariaDB Master     | 3306      |
| MariaDB Slave 1    | 3307      |
| MariaDB Slave 2    | 3308      |
| PostgreSQL Primary | 5432      |
| PostgreSQL Standby | 5433      |
| Redis              | 6379      |
