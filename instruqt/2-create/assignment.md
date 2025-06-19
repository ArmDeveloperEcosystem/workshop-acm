# Build LLM Application and push to Azure Container Registry

Now we need to ssh into our newly created virtual machine (VM), build our LLM application frontend and backend containers, and push those containers to our Azure Container Registry (ACR)

## Prepare our environment

Connect to our Azure Virtual machine we just created:

```bash,run
# TODO: Script to connect to Azure VM
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```

### Install dependencies

Ensure we have docker installed:

```bash,run
# TODO: Confirm these requirements
sudo apt-get update
sudo apt-get install docker.io -y
```

Clone our example code repo:

```bash,run
# TODO: Change this to curl to just get the two files we need:
# TODO: curl https://raw.githubusercontent.com/ArmDeveloperEcosystem/kubearchinspect/refs/heads/main/SECURITY.md --create-dirs -o pizza/Dockerfile 
git clone https://github.com/ArmDeveloperEcosystem/workshop-acm.git acm
cd acm
```

### Verify Hugging Face access to gated repos

If you haven't already done this

- Go to [Hugging Face Gated Repositories](https://huggingface.co/settings/gated-repos) and make sure **mistralai/Mistral-7B-Instruct-v0.2** is listed.
- If it is not listed:
  - Go to [https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2)
  - Click the **Agree and Access Repository** button

## Build backend container

Now we are ready to create the `acmworkshopllm` image, that contains our backend service for our LLM application.

### Create Access Token if you haven't already

- Go to [Hugging Face Access Tokens](https://huggingface.co/settings/tokens)
- Click the **Create new token** on the top right
- Change **Token type** to **Read**
- Give it any name
- Click the **Create token** button
- Copy the Access Token and save it somewhere safe you can copy to in the next step.

### Build acmworkshopllm image

Go to our backend server application folder:

```bash,run
# You should already be in the repo directory
cd server
```

Using the access token you just created, generate the server backend container:

```bash
sudo docker build -t acmworkshopllm . --build-arg HF_TOKEN=<paste your token from Hugging Face here>
```

### Test backend?

Get the image id for `acmworkshopllm`

```bash,run
sudo docker images
```

TODO: Show example of output

Let's make sure our build worked correctly by running the image:

```bash
sudo docker run -d -p 5000:5000 <image id>
```

Once it's up and running, test it out via a local curl call:

```bash,run
curl http://0.0.0.0:5000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.1",
    "stream": "true",
    "max_tokens": 200,
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello!"
      }
    ]
  }'
```

You should get a series of json messages as a response.

### Push backend to ACR

Now push the image we just created to our Azure Container Registry (ACR), so that it can be deployed on our Azure Kubernetes Service (AKS):

```bash,run
# TODO: Change this to the user's ACR
sudo docker tag acmworkshopllm:latest avinzarlez979/acmworkshopllm:latest
sudo docker push avinzarlez979/acmworkshopllm:latest
```

> [!NOTE]
> If you did not set your `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.

## Build frontend container

Navigate to the client folder:

```bash,run
cd ../client
```

We can build for both `amd64` and `arm64` and push the repo in one step:

```bash,run
# TODO: Confirm this works
# TODO: Do we need these?
# TODO: sudo docker buildx build --platform linux/amd64,linux/arm64 -t acmworkshopclient .
# TODO: sudo docker tag acmworkshopclient:latest avinzarlez979/acmworkshopclient:latest
# TODO: sudo docker push avinzarlez979/acmworkshopclient:latest
docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag avinzarlez979/acmworkshopclient:latest -t acmworkshopclient .
```

> [!NOTE]
> Once again, if you didn't set `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.

## Overview of our LLM application
===

Switch to the [Editor](tab-1) tab to take a look the application we will run today:

[button label="Editor"](tab-1)

The files we are interested in are in the `acm/server` and `acm/client` folders. In each there is a `Dockerfile` that defines how our application image will be created.

Torchchat is a library developed by the PyTorch team that facilitates running large language models (LLMs) seamlessly on a variety of devices. TorchAO (Torch Architecture Optimization) is a PyTorch library designed for enhancing the performance of ML models through different quantization and sparsity methods.

We start by cloning the torchao and torchchat repositories and then applying the Arm specific patches. Then override the installed PyTorch version with a specific version of PyTorch required to take advantage of Arm KleidiAI optimizations.

Finally we will download the [Mistral AI's 7B Instruct v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2) model and quantize it to int 4-bit using Kernels for PyTorch. By using channel-wise quantization, the weights are quantized independently across different channels, or groups of channels. This can improve accuracy over simpler quantization methods.

## Cleanup

When both images are pushed to the ACR, shut down your virtual machine to reduce resource spend:

```bash,run
# TODO: Write some code to shut down virtual machine.
```

Then click the **Next** button below.
