# Start dashboard
Guide link - https://krhsjung.notion.site/Dashboard-UI-1c268c4d323d8019b1b5c11e3bd44dcb?pvs=4

Hsjung dashboard link - https://hsjung.asuscomm.com/kubernetes

## Start dashboard
To deploy the dashboard pod, run the command below.
```shell
# apply dashboard configuration from web
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# apply dashboard configuration from local
kubectl apply -f 1.recommended.v2.7.0.yaml
```

## Update the service for dashboard
To use port 3000, run the command below.
```shell
# update dashboard service
kubectl apply -f 2.service.yaml
```

## Add the user
To add dashboard user, run the command below.
```shell
# Add the dashboard admin
kubectl apply -f 3.user-admin.yaml

# Add the dashboard readonly user
kubectl apply -f 4.user-readonly.yaml
```

## Bind the user to the ClusterRole
To bind the user to the ClusterRole, run the command below.
```shell
# Bind the admin to the cluster-admin ClusterRole, which has the highest level
kubectl apply -f 5.user-admin-cluster-role-binding.yaml

# Bind the readonly user to the view ClusterRole, which has the view level
kubectl apply -f 6.user-readonly-cluster-role-binding.yaml
```

## Create Bearer token for ServiceAccount
```shell
# Create Bearer token for admin
kubectl -n kubernetes-dashboard create token admin

# Create Bearer token for readonly user
kubectl -n kubernetes-dashboard create token readonly
```
