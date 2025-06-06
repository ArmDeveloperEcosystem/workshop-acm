## Before you begin
===

This workshop walks you through running the Meta Llama 3.1 Large Language Model (LLM) using PyTorch on Arm-based servers, with performance optimizations powered by KleidiAI’s INT4 quantization kernels. The model is deployed as an interactive browser-based chatbot application using Streamlit for the frontend and the Torchchat framework in PyTorch for the backend.

An Arm server running Ubuntu 22.04 LTS with at least 16 CPU cores, 64GB of RAM, and 50 GB of disk storage is required for this workshop. You don’t need to provision any infrastructure yourself. An instance with the necessary specifications has been automatically provisioned for you on this workshop platform.

## Overview
===

In this workshop, you will learn how to deploy and run a quantized LLM inference pipeline using PyTorch on Arm Neoverse V2-based CPUs. You’ll start by downloading the Meta Llama 3.1 model from the Hugging Face repository and apply 4-bit quantization using KleidiAI’s optimized INT4 kernels for PyTorch.

You will then serve the model as a chatbot application using Streamlit and Torchchat, allowing for a user-friendly browser-based interface backed by efficient PyTorch inference.

Finally, you will measure and observe performance metrics that highlight the benefits of running LLMs on Arm-based infrastructure. This hands-on experience showcases how to build scalable, efficient AI applications using open-source tools on Arm servers accelerated by KleidiAI.

## Log in to your Arm instance
===

A new Arm-based AWS EC2 instance has been created for you to use in this workshop. To connect to it, run the following command in the terminal
```bash,run
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```
When prompted, type "yes"

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