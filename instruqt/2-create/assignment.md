# Build LLM Application and push to Azure Container Registry

Now we need to ssh into our newly created virtual machine (VM), build our LLM application frontend and backend containers, and push those containers to our Azure Container Registry (ACR)

## Prepare our environment

Set the file permissions for our private key and get our VM's public ip address

```bash,run
chmod 400 private_key.pem 
export SERVER_IP=$(az vm show -d -g workshop-demo-rg-[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]-vm -n workshop-vm --query publicIps -o tsv)
```

Log into our ACR and pass the token to the virtual machine:

```bash,run
az acr login --name workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]] --expose-token --output tsv --query accessToken > acr_token.txt
scp -i private_key.pem acr_token.txt "azureadmin@$SERVER_IP":~/acr_token.txt
```

You will need to type "yes" to add the server's IP to the list of known hosts.

Connect to our VM via SSH:

```bash,run
ssh -i private_key.pem "azureadmin@$SERVER_IP"
```

### Install dependencies

Ensure we have docker installed:

```bash,run
sudo apt-get update
sudo apt-get install -y uidmap jq
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
echo '{"features": {"containerd-snapshotter": true}}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
sudo docker run --privileged --rm tonistiigi/binfmt --install all
```

### Log into Azure

We have to log into our Azure container registry:

```bash,run
sudo docker login workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin <<< $(cat acr_token.txt)
```

### Download Docker Files

Download the docker files we need for our project:

```bash,run
# TODO: Update these URLs to main branch
curl https://raw.githubusercontent.com/ArmDeveloperEcosystem/workshop-acm/refs/heads/development/images/client/Dockerfile --create-dirs -o client/Dockerfile 
curl https://raw.githubusercontent.com/ArmDeveloperEcosystem/workshop-acm/refs/heads/development/images/server/Dockerfile --create-dirs -o server/Dockerfile 
```

### Verify Hugging Face access to gated repos

If you haven't already done this

- Go to [Hugging Face Gated Repositories](https://huggingface.co/settings/gated-repos) and make sure **mistralai/Mistral-7B-Instruct-v0.2** is listed.
- If it is not listed:
  - Go to [https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2)
  - Click the **Agree and Access Repository** button

## Build backend container

Now we are ready to create the `acmworkshopllm` image, that contains our backend service for our LLM application.

### Create Access Token

- Go to [Hugging Face Access Tokens](https://huggingface.co/settings/tokens)
- Click the **Create new token** on the top right
- Change **Token type** to **Read**
- Give it any name
- Click the **Create token** button
- Copy the value to your clipboard and save it in our development environment

Copy the following code, then paste your key at the end:

```bash
export HF_TOKEN=
```

Now save that variable to a file we can pass into our docker image as a secret:

```bash,run
echo $HF_TOKEN > hf
```

> [!IMPORTANT]
> Make sure the only text in the file is your access token. You can double check the contents with `cat hf`.

### Build acmworkshopllm image

Using the access token you just created, generate the server backend container:

```bash,run
sudo docker buildx build -f server/Dockerfile --platform linux/arm64 -t workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopllm:latest --secret id=hf,src=./hf server
```

This step will take a while to download the model and convert it as part of creating the image.

### Test backend

Once our image is finally build, let's test it out to make sure it worked by running the image:

```bash, run
sudo docker run -d -p 5000:5000 workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopllm:latest
```

Once it's up and running, test it out via a local curl call:

```bash,run
curl http://0.0.0.0:5000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "minstral",
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

If everything is working, you will get a series of json messages as a response. They should look like something like this:

```json
data:{"id": "chatcmpl-79002c5d-4c9d-4d33-aa5e-b41df1811220", "choices": [{"delta": {"role": "assistant", "content": "Hello"}}], "created": 1750702192, "model": "minstral", "system_fingerprint": "cpu_torch.bfloat16", "object": "chat.completion.chunk"}

data:{"id": "chatcmpl-79002c5d-4c9d-4d33-aa5e-b41df1811220", "choices": [{"delta": {"role": "assistant", "content": "!"}, "index": 1}], "created": 1750702192, "model": "minstral", "system_fingerprint": "cpu_torch.bfloat16", "object": "chat.completion.chunk"}
```

### Push backend to ACR

Now push the image we just created to our Azure Container Registry (ACR), so that it can be deployed on our Azure Kubernetes Service (AKS):

```bash,run
sudo docker push workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopllm:latest
```

> [!NOTE]
> If you did not set your `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.

Due to the size of the image, the process will take a few minutes to upload the image to our ACR.

## Build frontend container

We can build for both `amd64` and `arm64` and push the repo in one step:

```bash,run
sudo docker buildx build -f client/Dockerfile --platform linux/amd64,linux/arm64 -t workshopacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]].azurecr.io/acmworkshopclient:latest --push client
```

> [!NOTE]
> Once again, if you didn't set `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.

Once the image is successfully pushed, click the **Check** button below.

## Overview of our LLM application
===

Switch to the [Editor](tab-1) tab to take a look the application we will run today:

[button label="Editor"](tab-1)

The files we are interested in are in the `server` and `client` folders. In each there is a `Dockerfile` that defines how our application image will be created.

Torchchat is a library developed by the PyTorch team that facilitates running large language models (LLMs) seamlessly on a variety of devices. TorchAO (Torch Architecture Optimization) is a PyTorch library designed for enhancing the performance of ML models through different quantization and sparsity methods.

We start by cloning the torchao and torchchat repositories and then applying the Arm specific patches. Then override the installed PyTorch version with a specific version of PyTorch required to take advantage of Arm KleidiAI optimizations.

Finally we will download the [Mistral AI's 7B Instruct v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2) model and quantize it to int 4-bit using Kernels for PyTorch. By using channel-wise quantization, the weights are quantized independently across different channels, or groups of channels. This can improve accuracy over simpler quantization methods.
