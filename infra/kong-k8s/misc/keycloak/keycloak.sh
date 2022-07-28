#!/bin/bash
kubectl create ns iam
helm install keycloak bitnami/keycloak --set auth.adminUser=keycloak,auth.adminPassword=keycloak --namespace iam

# helm install keycloak bitnami/keycloak \
#     --set auth.adminUser=keycloak,auth.adminPassword=keycloak \
#     --set extraEnvVars= 'KEYCLOAK_EXTRA_ARGS="-Dkeycloak.import=realm.json"' \
#     --namespace iam