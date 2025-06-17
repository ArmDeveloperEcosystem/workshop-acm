
# Azure cloud migration

This tutorial provides a step-by-step guide to TO REPLACE WITH ACTUAL DESCRIPTION

## TODO LIST

- [ ] Rewrite section 1 prepare
    - Get all account tokens will need throughout exercise
    - Use instruqt variables to store tokens???
- [ ] Rewrite section 2 create
    - Build application on Instruqt VM (x86?), with intent of being able to make docker image. Application should work by end locally
- [ ] Write section 3 Build
    - Create a standalone docker image that has model, application auto launched and open endpoint that can hit.
- [ ] Rewrite section 4 Terraform
    - Modify kubernetes node type to be compatible with new docker image
- [ ] Rewrite section 5 Import
    - Tweak to import image we created in step 3
- [ ] Rewrite section 6 Deploy
    - Rewrite to combine kubernetes deployment, but not using Go app and instead using LLM application
    - Instructions for using front end against public endpoint backend
- [ ] Write section 7 Demo
    - Write quick demo of KubeArchInspect
- [ ] Update this Readme to match actual content
- [ ] Import this repos content into Instruqt
- [ ] Test content in Instruqt

## Prerequisites

Before you begin, ensure you have the following installed:

- Azure CLI.
- Docker with Buildx enabled.
- Terraform.
- Kubernetes CLI (`kubectl`)

You will of course also need access to an Azure subscription.

## Challenges

### 1: Prepare required services

Make sure can log into and get tokens for:

- Hugging Face

### 2: Terraform Azure services

Deploy AKS, ACR, and VM to build image

### 3: Create AI application Docker image

Go into VM and log into Azure

Build docker image and push to ACR

### 4: Deploy kubernetes services

Deploy our service on our AKS

Test our endpoint through a load balancer

Highlight that end users just hit the one load balancer endpoint, and the application will run on arm or x86. Don’t have to remove existing x86 nodes to add arm ones, and then migrate towards arm overtime instead of all at once.

### 5: Front End

Run front end powered by kubernetes backend

### 6: Demo of KubeArchInspect

How you can use in your own Kubernetes deployments to check for arm compatibility.

## Conclusion

You have successfully created and deployed TO REPLACE WITH ACTUAL DESCRIPTION
