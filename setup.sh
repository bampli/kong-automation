#!/bin/bash
current="$PWD"

kind delete clusters kong-fc

# Kind cluster
cd $current
cd infra/kong-k8s/kind
./kind.sh

# Kong
cd $current
cd infra/kong-k8s/kong
./kong.sh

# Prometheus
cd $current
cd infra/kong-k8s/misc/prometheus/
./prometheus.sh

# Keycloak
cd $current
cd ./infra/kong-k8s/misc/keycloak
./keycloak.sh

HOST=$(kubectl get nodes --namespace kong -o jsonpath='{.items[0].status.addresses[0].address}')
PORT=$(kubectl get svc --namespace kong kong-kong-proxy -o jsonpath='{.spec.ports[0].nodePort}')
export PROXY_IP=${HOST}:${PORT}
echo "Kong Proxy: ${PROXY_IP}"

export SERVICE_PORT=$(kubectl get --namespace iam -o jsonpath="{.spec.ports[0].port}" services keycloak)
export SERVICE_IP=$(kubectl get svc --namespace iam keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Keycloak:   http://${SERVICE_IP}:${SERVICE_PORT}/"

# Apps
cd $current
cd infra/kong-k8s/misc/apps
kubectl create ns bets
kubectl apply -f . --recursive -n bets

# Kong CRD Plugins
cd $current
cd infra/kong-k8s/misc/apis/
kubectl apply -f kratelimit.yaml -n bets
kubectl apply -f kprometheus.yaml
kubectl apply -f bets-api.yaml -n bets
kubectl apply -f king.yaml -n bets
kubectl apply -f kopenid.yaml -n bets

# Port forward to Keycloak UI
#kubectl port-forward svc/keycloak 8080:80 -n iam