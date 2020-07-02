# TypeScript + Node POC

This is a project for me to learn about the interaction between Node.js and TypeScript.

## Goals

- [x] Create a simple web app using TypeScript and Node.js
- [x] Serve the web app within a Docker container
- [x] Deploy the containerized web app to the cloud using [AKS](https://docs.microsoft.com/en-us/azure/aks/)

## Getting Started

A lot of the configuration for this app has been referenced from [microsoft/TypeScript-Node-Starter](https://github.com/microsoft/TypeScript-Node-Starter), but I am keeping it as simple as possible.

1. Install dependencies
```shell
npm i
```
2. Run the server in Dev Mode
```shell
npm run watch
```
3. Check that it's working by going to [localhost:8080](http://localhost:8080) in your browser. You should see `"Hello, World!"`.

## Build

1. Make sure you have [Docker Desktop](https://docs.docker.com/desktop/) installed.
2. Build the app and Docker image
```shell
npm run build
```
3. Serve the app in a docker container
```shell
npm run serve-docker
```
4. Check that it's working by going to [localhost:8080](http://localhost:8080) in your browser. You should see `"Hello, World!"`.

## Deploy

1. Make sure you have [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed.
2. Authorize your local Azure CLI
```shell
az login
```
3. Install Kubernetes CLI
```shell
az aks install-cli
```
4. Duplicate `.env.example` as `.env`
```
cp .env.example .env
```
5. Edit `.env` to reflect desired values
6. Provision the necessary resources
```shell
./scripts/provision-resources.sh
```
7. Deploy the app to Kubernetes
```shell
./scripts/deploy.sh
```
8. Test the live app by going to the `EXTERNAL-IP` listed following this command
```shell
kubectl get service ts-node-poc --watch
```
