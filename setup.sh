#!/bin/bash
current="$PWD"

kind delete clusters  kind
kind delete clusters  kong-fc

# Kind cluster
cd $current
cd infra/kong-k8s/kind
./kind.sh

# Prometheus
cd $current
cd infra/kong-k8s/misc/prometheus/
./prometheus.sh

# Keycloak
cd $current
cd ./infra/kong-k8s/misc/keycloak
./keycloak.sh

export SERVICE_PORT=$(kubectl get --namespace iam -o jsonpath="{.spec.ports[0].port}" services keycloak)
export SERVICE_IP=$(kubectl get svc --namespace iam keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Keycloak running at http://${SERVICE_IP}:${SERVICE_PORT}/"

# Apps
cd $current
cd infra/kong-k8s/misc/apps
kubectl create ns bets
kubectl apply -f . --recursive -n bets

# CRD
cd $current
cd infra/kong-k8s/misc/apis/
kubectl apply -f kratelimit.yaml -n bets

