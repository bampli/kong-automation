# Kong & Kubernetes

## Quick start

### Kind 14.1
```
sudo curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64"
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

kind version
kind get clusters
```

### Kubectl
```
sudo curl -L "https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --short --client
```

### Helm
```
wget https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz
tar xvf helm-v3.4.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm version
rm helm-v3.4.1-linux-amd64.tar.gz
rm -rf linux-amd64

# Helm Charts
helm repo add kong https://charts.konghq.com
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami

```
https://github.com/Kong/charts
https://github.com/prometheus-community/helm-charts


### Create Cluster
```
cd infra/kong-k8s/kong-k8s/kind
./kind.sh

```

### Kong
```
cd infra/kong-k8s/kong-k8s/kong
./kong.sh

```

### Prometheus & Keycloak

https://github.com/prometheus-operator/kube-prometheus

```
./infra/kong-k8s/misc/prometheus/prometheus.sh

./infra/kong-k8s/misc/keycloak/keycloak.sh

export SERVICE_PORT=$(kubectl get --namespace iam -o jsonpath="{.spec.ports[0].port}" services keycloak)
export SERVICE_IP=$(kubectl get svc --namespace iam keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${SERVICE_IP}:${SERVICE_PORT}/"


```

### Apps

```
cd infra/kong-k8s/misc/apps
kubectl create ns bets
kubectl apply -f . --recursive -n bets

```

## Logs

```

kubectl get pods --all-namespaces
NAMESPACE            NAME                                                     READY   STATUS    RESTARTS      AGE
bets                 bets-5d498bc946-dgrlj                                    1/1     Running   0             2m11s
bets                 championships-6fcd58fdb-mzbxx                            1/1     Running   0             2m11s
bets                 matches-59c5f6f95f-cgsm7                                 1/1     Running   0             2m11s
bets                 players-7f4479ff94-27xbt                                 1/1     Running   0             2m11s
iam                  keycloak-0                                               1/1     Running   0             17m
iam                  keycloak-postgresql-0                                    1/1     Running   0             17m
kong                 kong-1654889531-kong-549d959645-prz8s                    2/2     Running   2 (56m ago)   56m
kube-system          coredns-6d4b75cb6d-6b7jv                                 1/1     Running   0             104m
kube-system          coredns-6d4b75cb6d-6qxbk                                 1/1     Running   0             104m
kube-system          etcd-kong-fc-control-plane                               1/1     Running   0             104m
kube-system          kindnet-nm6t4                                            1/1     Running   0             104m
kube-system          kube-apiserver-kong-fc-control-plane                     1/1     Running   0             104m
kube-system          kube-controller-manager-kong-fc-control-plane            1/1     Running   0             104m
kube-system          kube-proxy-cntrk                                         1/1     Running   0             104m
kube-system          kube-scheduler-kong-fc-control-plane                     1/1     Running   0             104m
local-path-storage   local-path-provisioner-9cd9bd544-w8vg6                   1/1     Running   0             104m
monitoring           alertmanager-prometheus-stack-kube-prom-alertmanager-0   2/2     Running   0             26m
monitoring           prometheus-prometheus-stack-kube-prom-prometheus-0       2/2     Running   0             26m
monitoring           prometheus-stack-grafana-7d8f4b6d67-n2xjm                3/3     Running   0             26m
monitoring           prometheus-stack-kube-prom-operator-5c9cf54d68-qjd2q     1/1     Running   0             26m
monitoring           prometheus-stack-kube-state-metrics-7fb88f5df-qggbm      1/1     Running   0             26m
monitoring           prometheus-stack-prometheus-node-exporter-fg5h4          1/1     Running   0             26m

```

```
k describe pods kong-1654889531-kong-549d959645-prz8s -n kong
Name:         kong-1654889531-kong-549d959645-prz8s
Namespace:    kong
Priority:     0
Node:         kong-fc-control-plane/172.19.0.2
Start Time:   Fri, 10 Jun 2022 16:32:16 -0300
Labels:       app=kong-1654889531-kong
              app.kubernetes.io/component=app
              app.kubernetes.io/instance=kong-1654889531
              app.kubernetes.io/managed-by=Helm
              app.kubernetes.io/name=kong
              app.kubernetes.io/version=2.8
              helm.sh/chart=kong-2.9.1
              pod-template-hash=549d959645
              version=2.8
Annotations:  kuma.io/gateway: enabled
              prometheus.io/port: 9542
              prometheus.io/scrape: true
              traffic.sidecar.istio.io/includeInboundPorts: 
Status:       Running
IP:           10.244.0.5
IPs:
  IP:           10.244.0.5
Controlled By:  ReplicaSet/kong-1654889531-kong-549d959645
Init Containers:
  clear-stale-pid:
    Container ID:  containerd://c86df15565c444098035ffa0d9f7281f2bfd7eae1ba2a078c72d64ba012a90c8
    Image:         claudioed/kong-oidc-jwt:latest
    Image ID:      docker.io/claudioed/kong-oidc-jwt@sha256:9cfeb08854549d6ecd4dcede14d2aa6e6829200ded5bcc396a643a7ae789e1c7
    Port:          <none>
    Host Port:     <none>
    Command:
      rm
      -vrf
      $KONG_PREFIX/pids
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 10 Jun 2022 16:32:28 -0300
      Finished:     Fri, 10 Jun 2022 16:32:28 -0300
    Ready:          True
    Restart Count:  0
    Environment:
      KONG_ADMIN_ACCESS_LOG:        /dev/stdout
      KONG_ADMIN_ERROR_LOG:         /dev/stderr
      KONG_ADMIN_GUI_ACCESS_LOG:    /dev/stdout
      KONG_ADMIN_GUI_ERROR_LOG:     /dev/stderr
      KONG_ADMIN_LISTEN:            0.0.0.0:8001, 0.0.0.0:8444 ssl
      KONG_CLUSTER_LISTEN:          off
      KONG_DATABASE:                off
      KONG_KIC:                     on
      KONG_LUA_PACKAGE_PATH:        /opt/?.lua;/opt/?/init.lua;;
      KONG_NGINX_WORKER_PROCESSES:  2
      KONG_PLUGINS:                 bundled,oidc,kong-jwt2header
      KONG_PORTAL_API_ACCESS_LOG:   /dev/stdout
      KONG_PORTAL_API_ERROR_LOG:    /dev/stderr
      KONG_PORT_MAPS:               80:8000, 443:8443
      KONG_PREFIX:                  /kong_prefix/
      KONG_PROXY_ACCESS_LOG:        /dev/stdout
      KONG_PROXY_ERROR_LOG:         /dev/stderr
      KONG_PROXY_LISTEN:            0.0.0.0:8000, 0.0.0.0:8443 http2 ssl
      KONG_STATUS_LISTEN:           0.0.0.0:8100
      KONG_STREAM_LISTEN:           off
    Mounts:
      /kong_prefix/ from kong-1654889531-kong-prefix-dir (rw)
      /tmp from kong-1654889531-kong-tmp (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-lngwc (ro)
Containers:
  ingress-controller:
    Container ID:   containerd://45f81c68a3ea341130d63d98817645b32fb5d0eb65c500f71f12580f1b1d5fc4
    Image:          kong/kubernetes-ingress-controller:2.3
    Image ID:       docker.io/kong/kubernetes-ingress-controller@sha256:5e66021b64a802209912ccd4de96c68517c5c616c7597f9e3cbde2fd69a24f4c
    Port:           10255/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 10 Jun 2022 16:33:00 -0300
    Last State:     Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Fri, 10 Jun 2022 16:32:39 -0300
      Finished:     Fri, 10 Jun 2022 16:32:39 -0300
    Ready:          True
    Restart Count:  2
    Liveness:       http-get http://:10254/healthz delay=5s timeout=5s period=10s #success=1 #failure=3
    Readiness:      http-get http://:10254/healthz delay=5s timeout=5s period=10s #success=1 #failure=3
    Environment:
      POD_NAME:                               kong-1654889531-kong-549d959645-prz8s (v1:metadata.name)
      POD_NAMESPACE:                          kong (v1:metadata.namespace)
      CONTROLLER_ELECTION_ID:                 kong-ingress-controller-leader-kong
      CONTROLLER_INGRESS_CLASS:               kong
      CONTROLLER_KONG_ADMIN_TLS_SKIP_VERIFY:  true
      CONTROLLER_KONG_ADMIN_URL:              https://localhost:8444
      CONTROLLER_PUBLISH_SERVICE:             kong/kong-1654889531-kong-proxy
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-lngwc (ro)
  proxy:
    Container ID:   containerd://22a63c28bdf9a427b7ee8b9bc064630d389e724b70928393007770e3f2a852fd
    Image:          claudioed/kong-oidc-jwt:latest
    Image ID:       docker.io/claudioed/kong-oidc-jwt@sha256:9cfeb08854549d6ecd4dcede14d2aa6e6829200ded5bcc396a643a7ae789e1c7
    Ports:          8001/TCP, 8444/TCP, 8000/TCP, 8443/TCP, 8100/TCP
    Host Ports:     0/TCP, 0/TCP, 0/TCP, 0/TCP, 0/TCP
    State:          Running
      Started:      Fri, 10 Jun 2022 16:32:38 -0300
    Ready:          True
    Restart Count:  0
    Liveness:       http-get http://:status/status delay=5s timeout=5s period=10s #success=1 #failure=3
    Readiness:      http-get http://:status/status delay=5s timeout=5s period=10s #success=1 #failure=3
    Environment:
      KONG_ADMIN_ACCESS_LOG:        /dev/stdout
      KONG_ADMIN_ERROR_LOG:         /dev/stderr
      KONG_ADMIN_GUI_ACCESS_LOG:    /dev/stdout
      KONG_ADMIN_GUI_ERROR_LOG:     /dev/stderr
      KONG_ADMIN_LISTEN:            0.0.0.0:8001, 0.0.0.0:8444 ssl
      KONG_CLUSTER_LISTEN:          off
      KONG_DATABASE:                off
      KONG_KIC:                     on
      KONG_LUA_PACKAGE_PATH:        /opt/?.lua;/opt/?/init.lua;;
      KONG_NGINX_WORKER_PROCESSES:  2
      KONG_PLUGINS:                 bundled,oidc,kong-jwt2header
      KONG_PORTAL_API_ACCESS_LOG:   /dev/stdout
      KONG_PORTAL_API_ERROR_LOG:    /dev/stderr
      KONG_PORT_MAPS:               80:8000, 443:8443
      KONG_PREFIX:                  /kong_prefix/
      KONG_PROXY_ACCESS_LOG:        /dev/stdout
      KONG_PROXY_ERROR_LOG:         /dev/stderr
      KONG_PROXY_LISTEN:            0.0.0.0:8000, 0.0.0.0:8443 http2 ssl
      KONG_STATUS_LISTEN:           0.0.0.0:8100
      KONG_STREAM_LISTEN:           off
      KONG_NGINX_DAEMON:            off
    Mounts:
      /kong_prefix/ from kong-1654889531-kong-prefix-dir (rw)
      /tmp from kong-1654889531-kong-tmp (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-lngwc (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kong-1654889531-kong-prefix-dir:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kong-1654889531-kong-tmp:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-lngwc:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Pulling    2m55s                  kubelet            Pulling image "claudioed/kong-oidc-jwt:latest"
  Normal   Scheduled  2m55s                  default-scheduler  Successfully assigned kong/kong-1654889531-kong-549d959645-prz8s to kong-fc-control-plane
  Normal   Pulled     2m43s                  kubelet            Successfully pulled image "claudioed/kong-oidc-jwt:latest" in 11.525079119s
  Normal   Created    2m43s                  kubelet            Created container clear-stale-pid
  Normal   Started    2m43s                  kubelet            Started container clear-stale-pid
  Normal   Pulling    2m38s                  kubelet            Pulling image "kong/kubernetes-ingress-controller:2.3"
  Normal   Created    2m33s                  kubelet            Created container proxy
  Normal   Pulled     2m33s                  kubelet            Successfully pulled image "kong/kubernetes-ingress-controller:2.3" in 5.105887523s
  Normal   Started    2m33s                  kubelet            Started container proxy
  Normal   Pulled     2m33s                  kubelet            Container image "claudioed/kong-oidc-jwt:latest" already present on machine
  Warning  BackOff    2m24s (x5 over 2m31s)  kubelet            Back-off restarting failed container
  Normal   Started    2m11s (x3 over 2m33s)  kubelet            Started container ingress-controller
  Normal   Pulled     2m11s (x2 over 2m32s)  kubelet            Container image "kong/kubernetes-ingress-controller:2.3" already present on machine
  Normal   Created    2m11s (x3 over 2m33s)  kubelet            Created container ingress-controller
```