
# Azure cloud migration

This tutorial provides a step-by-step guide to TO REPLACE WITH ACTUAL DESCRIPTION

## TODO LIST

- [ ] Rewrite section 1 prepare
    - Get all account tokens will need throughout exercise
    - Use instruqt variables to store tokens???
- [ ] Rewrite section 2 create
    - Build application on Instruqt VM (x86?), with intent of being able to make docker image. Application should work by end locally
- [ ] Rewrite section 3 Build
    - Create a standalone docker image that has model, application auto launched and open endpoint that can hit.
- [ ] Rewrite section 4 Terraform
    - Modify kubernetes node type to be compatible with new docker image
- [ ] Rewrite section 5 Import
    - Tweak to import image we created in step 3
- [ ] Rewrite section 6 Deploy
    - Rewrite to combine kubernetes deployment, but not using Go app and instead using LLM application
    - Instructions for using front end against public endpoint backend
- [ ] Rewrite section 7 Demo
    - Write quick demo of KubeArchInspect
- [ ] Update this Readme to match actual content

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

- GitHub
- Hugging Face
- Docker Hub

Fork workshop repo?

### 2: Create AI application

Local LLM generating a message and sending it back via API call

Also as part of return message, include the debugging info of if the compute happened to run on arm or x86

Mention if not test running front end?

### 3: Build multi architect docker image that contains LLM+Application

Possibly some CI/CD with github actions to build

### 4: Terraform Azure services

Import image from docker into ACR

### 5: Import docker image

Import from docker hub to deployed ACR

### 6: Deploy kubernetes services

Test our endpoint through a load balancer across x86 and arm based nodes

Run front end powered by kubernetes backend

Highlight that end users just hit the one load balancer endpoint, and the application will run on arm or x86. 

Don’t have to remove existing x86 nodes to add arm ones, and then migrate towards arm overtime instead of all at once.

### 7: Demo of KubeArchInspect

How you can use in your own Kubernetes deployments to check for arm compatibility.

## Conclusion

You have successfully created and deployed TO REPLACE WITH ACTUAL DESCRIPTION
