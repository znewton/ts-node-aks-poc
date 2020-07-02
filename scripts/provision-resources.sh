#! /usr/bin/env bash

# Read from .env file
if [ ! -f ".env" ]; then
    echo ".env does not exist"
    exit 1
fi
export $(egrep -v '^#' .env | xargs)

# Set Azure Subscription
az account set --subscription $AZURE_SUBSCRIPTION
# Create Resource Group
RG_EXISTS=$(az group exists --name $AZURE_RESOURCE_GROUP --subscription $AZURE_SUBSCRIPTION)
if [ ! $RG_EXISTS == "false" ]; then
    echo "$AZURE_RESOURCE_GROUP resource group exists. Skipping creation"
else
    echo "Creating $AZURE_RESOURCE_GROUP resource group in $AZURE_LOCATION region"
    az group create --name $AZURE_RESOURCE_GROUP --location $AZURE_LOCATION
fi
# Set some defaults for commands down the road
az configure --defaults location=$AZURE_LOCATION group=$AZURE_RESOURCE_GROUP acr=$AZURE_CONTAINER_REGISTRY

# Create Azure Container Registry
ACR_EXISTS=$(az acr check-name)
# Get a single JSON value (from https://askubuntu.com/a/1167323)
function jsonValue() {
    KEY=$1
    num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}
if [ $(echo $ACR_EXISTS | jsonValue nameAvailable) == "true" ]; then
    echo "Creating $AZURE_CONTAINER_REGISTRY"
    az acr create --sku $AZURE_ACR_SKU
else
    echo "$AZURE_CONTAINER_REGISTRY name not available."
    echo "  $(echo $ACR_EXISTS | jsonValue message)"
    echo "  Skipping creation"
fi

# Create Azure Kubernetes Cluster
AKS_CLUSTERS=$(az aks list)
if [[ ! "$AKS_CLUSTER" == *"$AZURE_KUBERNETES_CLUSTER"* ]]; then
    echo "Creating $AZURE_KUBERNETES_CLUSTER Azure Kubernetes Cluster with $AZURE_KUBERNETES_NODES nodes"
    az aks create --name "$AZURE_KUBERNETES_CLUSTER" --node-count "$AZURE_KUBERNETES_NODES" --generate-ssh-keys --attach-acr "$AZURE_CONTAINER_REGISTRY"
else
    echo "$AZURE_KUBERNETES_CLUSTER Azure Kubernetes Cluster exists. Skipping creation"
fi
