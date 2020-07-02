#! /usr/bin/env bash

npm run build

# Read from .env file
if [ ! -f ".env" ]; then
    echo ".env does not exist"
    exit 1
fi
export $(egrep -v '^#' .env | xargs)

# Set Azure Subscription
az account set --subscription $AZURE_SUBSCRIPTION
# Set some defaults for commands down the road
az configure --defaults location=$AZURE_LOCATION group=$AZURE_RESOURCE_GROUP acr=$AZURE_CONTAINER_REGISTRY

# Log into ACR
echo "Logging into $AZURE_CONTAINER_REGISTRY Azure Container Registry"
az acr login
# Get ACR Login Server name
ACR_LOGIN_SERVER=$(az acr list --query "[].{acrLoginServer:loginServer}" --output tsv)
# Tag build version
VERSION="$(date +%s)"
IMAGE_NAME="ts-node-poc"
docker tag "$USER/$IMAGE_NAME" "$ACR_LOGIN_SERVER/$IMAGE_NAME:$VERSION"
# Push images to Azure Container Registry
echo "Pushing $USER/$IMAGE_NAME:$VERSION to $ACR_LOGIN_SERVER"
docker push "$ACR_LOGIN_SERVER/$IMAGE_NAME:$VERSION"

# Verify image made it to Azure Container Registry
ACR_IMAGES=$(az acr repository list --output tsv)
if [[ ! $ACR_IMAGES == *"$IMAGE_NAME"* ]]; then
    echo "Failed to upload image"
    exit 1
fi

# Connect to Azure Kubernetes Cluster
az aks get-credentials --name $AZURE_KUBERNETES_CLUSTER

# Generate AKS Manifest file
cat > aks-manifest.yaml <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $IMAGE_NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $IMAGE_NAME
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5 
  template:
    metadata:
      labels:
        app: $IMAGE_NAME
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: $IMAGE_NAME
        image: $ACR_LOGIN_SERVER/$IMAGE_NAME:$VERSION
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: 250m
          limits:
            cpu: 500m
---
apiVersion: v1
kind: Service
metadata:
  name: $IMAGE_NAME
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: $IMAGE_NAME
YAML

kubectl apply -f aks-manifest.yaml