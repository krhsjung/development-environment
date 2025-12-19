# Kind (Kubernetes in Docker)

로컬 개발 환경을 위한 Kind 클러스터 설정입니다.

> 상세 가이드: [Kind Kubernetes In Docker setting On MacOS](https://krhsjung.notion.site/Kind-Kubernetes-In-Docker-setting-On-MacOS-1b368c4d323d80c8ab68cc6e05554c1f?pvs=4)

## 파일 구조

| 파일 | 설명 |
|------|------|
| `create-cluster.sh` | 클러스터 생성 + host.docker.internal DNS 자동 설정 스크립트 |
| `kind-config.yaml` | 기본 설정 (NodePort 30000만 매핑) |
| `kind-config-full-port-range.yaml` | 전체 NodePort 범위 (30000-32767) 매핑 |

## 클러스터 생성

### 권장: 스크립트 사용 (host.docker.internal 자동 설정)

```shell
# 기본 클러스터명 'kind'로 생성
./create-cluster.sh

# 커스텀 클러스터명으로 생성
./create-cluster.sh my-cluster
```

스크립트가 자동으로 수행하는 작업:
- Kind 클러스터 생성 (full port range 설정 사용)
- CoreDNS에 `host.docker.internal` DNS 설정 추가
- Pod에서 호스트 머신 접근 가능

### 수동 생성

```shell
# 기본 설정 (NodePort 30000만 필요한 경우)
kind create cluster --name kind --config kind-config.yaml

# 전체 NodePort 범위가 필요한 경우
kind create cluster --name kind --config kind-config-full-port-range.yaml
```

## 클러스터 삭제

```shell
# 특정 클러스터 삭제
kind delete cluster --name kind

# 모든 클러스터 삭제
kind delete clusters --all
```

## host.docker.internal 테스트

```shell
kubectl run test --rm -it --image=alpine --restart=Never -- nslookup host.docker.internal
```
