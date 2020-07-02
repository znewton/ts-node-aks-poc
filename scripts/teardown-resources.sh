#! /usr/bin/env bash

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

echo "Deleting $AZURE_KUBERNETES_CLUSTER Azure Kubernetes Cluster"
az aks delete --name $AZURE_KUBERNETES_CLUSTER

echo "Deleting $AZURE_CONTAINER_REGISTRY Azure Container Registry"
az acr delete