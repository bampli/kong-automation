# Kong & Kubernetes

## Installing Tools

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

helm repo update

```
https://github.com/Kong/charts
https://github.com/prometheus-community/helm-charts


## Setup

To install everything at once, just run *./setup.sh* to recreate the cluster and the containers. Following are the corresponding commands.

```
./setup.sh

```

After creation, a bets realm can be imported:

```
./infra/kong-k8s/misc/keycloak/realm.json

```

### Kind Cluster
```
cd infra/kong-k8s/kind
./kind.sh

```

### Kong
```
cd infra/kong-k8s/kong
./kong.sh

```

### Prometheus & Keycloak

https://github.com/prometheus-operator/kube-prometheus

```
cd ./infra/kong-k8s/misc/prometheus/
./prometheus.sh

cd ./infra/kong-k8s/misc/keycloak/
./keycloak.sh

export SERVICE_PORT=$(kubectl get --namespace iam -o jsonpath="{.spec.ports[0].port}" services keycloak)
export SERVICE_IP=$(kubectl get svc --namespace iam keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Keycloak running at http://${SERVICE_IP}:${SERVICE_PORT}/"


```

### All apps

```
cd infra/kong-k8s/misc/apps
kubectl create ns bets
kubectl apply -f . --recursive -n bets

```

## Some info about status

```

kubectl get pods --all-namespaces

k describe pods kong-kong-778665bf9b-lm2dg -n kong

k logs kong-kong-778665bf9b-lm2dg proxy -f -n kong
```

### Token OpenID JWT

```
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "ibBMfHpxHP9TdoihFLDjLjljtON0CXlfXYDbSv74uvc"
}

{
  "exp": 1658527818,
  "iat": 1658527518,
  "jti": "a0563fa3-5c40-448f-a5bf-97fefb252ec5",
  "iss": "http://keycloak.iam/realms/bets",
  "aud": "account",
  "sub": "f7f2766e-1d15-4c78-940d-b7601fa399f2",
  "typ": "Bearer",
  "azp": "kong",
  "session_state": "de12335b-0539-4b4b-aece-24c74565a3b6",
  "acr": "1",
  "realm_access": {
    "roles": [
      "offline_access",
      "uma_authorization",
      "default-roles-bets"
    ]
  },
  "resource_access": {
    "account": {
      "roles": [
        "manage-account",
        "manage-account-links",
        "view-profile"
      ]
    }
  },
  "scope": "openid profile email",
  "sid": "de12335b-0539-4b4b-aece-24c74565a3b6",
  "email_verified": false,
  "preferred_username": "maria"
}

```