# Kong & Kubernetes

## Install

### Quick start
```

# Kind 14.1
sudo curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64"
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
# test
kinf version
kind get clusters

# Kubectl
sudo curl -L "https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --short --client

# Create Cluster
cd infra/kong-k8s/kind
./kind.sh

```