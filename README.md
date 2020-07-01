# TypeScript + Node POC

This is a project for me to learn about the interaction between Node.js and TypeScript.

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

## Build & Deploy

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