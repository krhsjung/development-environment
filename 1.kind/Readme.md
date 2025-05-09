# Start kind
Guide link - https://krhsjung.notion.site/Kind-Kubernetes-In-Docker-setting-On-MacOS-1b368c4d323d80c8ab68cc6e05554c1f?pvs=4

### Start kind
```shell
# create cluster kind
kind create cluster --name kind --config kind-config.yaml

# create cluster kind for full port range
kind create cluster --name kind --config kind-config-full-port-range.yaml
```

### Delete kind
```shell
# delete one cluster
kind delete cluster --name kind

# delete all clusters
kind delete clusters --all
```