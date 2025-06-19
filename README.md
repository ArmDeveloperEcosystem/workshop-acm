
# Arm cloud migration

This tutorial provides a step-by-step guide to:

- Deploy Azure services via terraform
- Create docker images of an example LLM application
- Deploy onto Azure Kubernetes Services (AKS)

This is meant to be consumed via an Instruqt workshop, but you can follow along with just this repo.

## Prerequisites

Before you begin, ensure you have the following installed:

- Azure CLI.
- Docker with Buildx enabled.
- Terraform.
- Kubernetes CLI (`kubectl`)

You will of course also need access to an Azure subscription.

## Challenges

### 1: Terraform Azure services

Deploy AKS, ACR, and a VM to build images.

### 2: Create AI application Docker image

Make sure can log into and get tokens for Hugging Face.

Build docker images and push them to our ACR

### 3: Deploy into kubernetes

Deploy our backend llm service on our AKS.

Test our endpoint through a load balancer. The application will run on any node it can but still be consume via the same common load balancer endpoint.

Deploy our frontend client service on our AKS.

Test our frontend is able to successfully connect to our backend. Note that our client and server are running on different architecture.

### 4: Demo of KubeArchInspect

Show how you can use this tool in your own Kubernetes deployments to check for arm compatibility.

## Conclusion

You don’t have to remove existing x86 nodes to add arm ones using multi architectural deployments. That way you can migrate towards `arm64` on your pace, instead of all at once.

You have successfully created and deployed this example project. Let us know if there was useful for you, or if there are other workshops you'd like to see from us in the future.
