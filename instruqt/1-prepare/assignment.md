# Azure Cloud Migration workshop

This workshop demonstrates how to create and run a quantized LLM inference pipeline using PyTorch, then deploy the backend to the cloud using a multi-architectural Azure Kubernetes service with both AMD and Arm based nodes. You will then connect a chatbot application using Streamlit and Torchchat to the AKS load balancer, allowing for a user-friendly browser-based interface powered by PyTorch and running on a scalable Kubernetes based backend.

Through instruqt you have been given:

- An Azure subscription
- A terminal to work in with the required tools (git, azure cli, terraform) already installed

> [!NOTE]
> Your Azure CLI should already be configured by Instruqt and authorized to the correct Azure subscription.
> You can confirm this by running `az account show`

## Install the necessary tools
===

```bash,run
sudo apt update
sudo apt install gcc g++ build-essential python3-pip python3-venv google-perftools -y
```
If prompted with a screen that asks "Which services should be restarted?" Press Enter.

## Verify Hugging Face access to gated repos
===
If you haven't already done this
- go to [Hugging Face Gated Repositories](https://huggingface.co/settings/gated-repos) and make sure either **Meta's Llama 3.1 models & evals** or **mistralai/Mistral-7B-Instruct-v0.2** is listed.
- If neither is listed
	- Go to [https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2)
	- Click the **Agree and Access Repository** button

## Create and store and Access Token if you haven't already
===
- Go to [Hugging Face Access Tokens](https://huggingface.co/settings/tokens)
- Click the **Create new token** on the top right
- Change **Token type** to **Read**
- Give it any name
- Click the **Create token** button
- Copy the Access Token and save it somewhere safe