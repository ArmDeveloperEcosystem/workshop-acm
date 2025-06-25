# AKS Kubernetes Deployment Files

This folder contains four Kubernetes deployment files used to manage application resources on Azure Kubernetes Service (AKS). Each file defines a specific component of the application stack.

## Deployment Files

1. **llmserver-service.yaml**
    - Exposes the deployed backend application within the cluster.
    - Defines a Kubernetes Service to provide stable networking and load balancing.
    - Maps traffic to the appropriate deployment pods.

2. **llmserver-deployment.yaml**
    - Defines the deployment for the backend application.
    - Specifies the number of pod replicas to run.
    - Sets container image and resource requests/limits.

3. **client-service.yaml**
    - Exposes the deployed client application within the cluster.
    - Defines a Kubernetes Service to provide stable networking and load balancing.
    - Maps traffic to the appropriate deployment pods.

4. **client-deployment.yaml**
    - Defines the deployment for the client application.
    - Specifies the number of pod replicas to run.
    - Sets container image, resource requests/limits, and environment variable.

## Usage

Ensure you have the necessary permissions and context set for your AKS cluster.

```sh
az aks get-credentials --resource-group < resource group name > --name < aks name > --overwrite-existing
```

Apply each file in order using `kubectl`:

```sh
kubectl apply -f llmserver-service.yaml
kubectl apply -f llmserver-deployment.yaml
kubectl apply -f client-service.yaml
kubectl apply -f client-deployment.yaml
```
