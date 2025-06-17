sudo apt-get update
sudo apt-get install docker.io -y
sudo docker build -t acmworkshopllm . --build-arg HF_TOKEN=h






# Import into Azure Container Registry

Now we need to import an image of our Go application into our newly created Azure Container Registry.

## Overview of our Go application
===

Switch to the [Editor](tab-1) tab to take a look the application we will run today:

[button label="Editor"](tab-1)

We have a `Dockerfile`, that defines how our application image will be created. The application itself is incredibly simple, responding to pings with some basic diagnostic information. This will allow us to see which node our application is deployed on.

## Import image into ACR
===

To save some time, I have already created our docker image and uploaded it to a private repository.

In your [Terminal tab](tab-0), write the following command to prepare the current working directory for use with Terraform:

[button label="Terminal"](tab-0)

```bash,run
az acr import --name armacr[[ Instruqt-Var key="randomid" hostname="cloud-client" ]] --source docker.io/avinzarlez979/multi-arch:latest --image multi-arch:latest
```

This will import the public image of this Go application available at `docker.io/avinzarlez979/multi-arch:latest` into your newly created ACR.

> [!NOTE]
> If you did not set your `random_id` to `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]` during deployment, then you will have to edit the above line to use the actual name of your deployed Azure Container Registry.








## Set up your Python virtual environment
===

First, connect back to your Arm instance
```bash,run
ssh -i "[[ Instruqt-Var key="PEM_KEY" hostname="cloud-container" ]]" ubuntu@[[ Instruqt-Var key="EXTERNAL_IP" hostname="cloud-container" ]]
```
Then set up a Python virtual environment to isolate dependencies:
```bash,run
python3 -m venv torch_env
source torch_env/bin/activate
```

## Install PyTorch and optimized libraries
===
Torchchat is a library developed by the PyTorch team that facilitates running large language models (LLMs) seamlessly on a variety of devices. TorchAO (Torch Architecture Optimization) is a PyTorch library designed for enhancing the performance of ML models through different quantization and sparsity methods.

Start by cloning the torchao and torchchat repositories and then applying the Arm specific patches:

```bash,run
git clone --recursive https://github.com/pytorch/ao.git
cd ao
git checkout 174e630af2be8cd18bc47c5e530765a82e97f45b
wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-Feat-Add-support-for-kleidiai-quantization-schemes.patch
git apply --whitespace=nowarn 0001-Feat-Add-support-for-kleidiai-quantization-schemes.patch
cd ../

git clone --recursive https://github.com/pytorch/torchchat.git
cd torchchat
git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6
wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-modified-generate.py-for-cli-and-browser.patch
wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch
git apply 0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch
git apply --whitespace=nowarn 0001-modified-generate.py-for-cli-and-browser.patch
pip install -r requirements.txt
```

You will now override the installed PyTorch version with a specific version of PyTorch required to take advantage of Arm KleidiAI optimizations:

```bash,run
wget https://github.com/ArmDeveloperEcosystem/PyTorch-arm-patches/raw/main/torch-2.5.0.dev20240828+cpu-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
pip install --force-reinstall torch-2.5.0.dev20240828+cpu-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
cd ..
pip uninstall torchao && cd ao/ && rm -rf build && python setup.py install
```

## Login to Hugging Face
===
You can now download the LLM.

Install the [Hugging Face CLI](https://huggingface.co/docs/huggingface_hub/main/en/guides/cli) application.
```bash,run
pip install -U "huggingface_hub[cli]"
```

Log in to the Hugging Face repository and enter your Access Token key from Hugging face.
```bash,run
huggingface-cli login
```
Paste in your Hugging Face token and press Enter. Type "n" when prompted to store as a git credential.

Before you can download the Llama 3.1 model, you must have accepted the license agreement at: [Meta Llama 3.1](https://huggingface.co/meta-llama/Meta-Llama-3.1-8B-Instruct). I will provide alternative commands to download another model if you haven't already done so.

**Choose the next step based on the model you're going to run**
## Downloading and Quantizing the LLM Model (Llama 3.1)
===

In this step, you will download the [Meta Llama3.1 8B Instruct model](https://huggingface.co/meta-llama/Meta-Llama-3.1-8B-Instruct) and quantize the model to int 4-bit using Kernels for PyTorch. By using channel-wise quantization, the weights are quantized independently across different channels, or groups of channels. This can improve accuracy over simpler quantization methods.


```bash,run
cd ../torchchat
python torchchat.py export llama3.1 --output-dso-path exportedModels/llama3.1.so --quantize config/data/aarch64_cpu_channelwise.json --device cpu --max-seq-length 1024
```
The output from this command should look like:

```output
linear: layers.31.feed_forward.w1, in=4096, out=14336
linear: layers.31.feed_forward.w2, in=14336, out=4096
linear: layers.31.feed_forward.w3, in=4096, out=14336
linear: output, in=4096, out=128256
Time to quantize model: 44.14 seconds
-----------------------------------------------------------
Exporting model using AOT Inductor to /home/ubuntu/torchchat/exportedModels/llama3.1.so
The generated DSO model can be found at: /home/ubuntu/torchchat/exportedModels/llama3.1.so
```
## Downloading and Quantizing the LLM Model (Mistral)
===

In this step, you will download the [Mistral AI's 7B Instruct v0.2](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2) and quantize the model to int 4-bit using Kernels for PyTorch. By using channel-wise quantization, the weights are quantized independently across different channels, or groups of channels. This can improve accuracy over simpler quantization methods.


```bash,run
cd ../torchchat
python torchchat.py export mistral --output-dso-path exportedModels/mistral.so --quantize config/data/aarch64_cpu_channelwise.json --device cpu --max-seq-length 1024
```
The output from this command should look like:

```output
linear: layers.31.feed_forward.w1, in=4096, out=14336
linear: layers.31.feed_forward.w2, in=14336, out=4096
linear: layers.31.feed_forward.w3, in=4096, out=14336
linear: output, in=4096, out=128256
Time to quantize model: 44.14 seconds
-----------------------------------------------------------
Exporting model using AOT Inductor to /home/ubuntu/torchchat/exportedModels/mistral.so
The generated DSO model can be found at: /home/ubuntu/torchchat/exportedModels/mistral.so
```

## Running LLM Inference on Arm CPU
===
You can now run the LLM on the Arm CPU on your server.

To run the model inference:

### Llama 3.1
```bash,run
LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python torchchat.py generate llama3.1 --dso-path exportedModels/llama3.1.so --device cpu --max-new-tokens 32 --chat
```

### Mistral 7B v0.2
```bash,run
LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python torchchat.py generate mistral --dso-path exportedModels/mistral.so --device cpu --max-new-tokens 32 --chat
```
When asked if you want to enter a system prompt, type "n" or "no".

Here you can test that everything is working by asking a question. The output is limited in the number of tokens it will produce, but that won't cause any issues in the next steps.

An example prompt:
```bash,run
What's the weather in Boston typically like?
```

The output from running the inference will look like:

```output
PyTorch version 2.5.0.dev20240828+cpu available.
Warning: checkpoint path ignored because an exported DSO or PTE path specified
Warning: checkpoint path ignored because an exported DSO or PTE path specified
Using device=cpu
Loading model...
Time to load model: 0.04 seconds
-----------------------------------------------------------
Starting Interactive Chat
Entering Chat Mode. Will continue chatting back and forth with the language model until the models max context length of 8192 tokens is hit or until the user says /bye
Do you want to enter a system prompt? Enter y for yes and anything else for no.
no
User: What's the weather in Boston like?
Model: Boston, Massachusetts!

Boston's weather is known for being temperamental and unpredictable, especially during the spring and fall months. Here's a breakdown of the typical
=====================================================================
Input tokens        :   18
Generated tokens    :   32
Time to first token :   0.66 s
Prefill Speed       :   27.36 t/s
Generation  Speed   :   24.6 t/s
=====================================================================

Bandwidth achieved: 254.17 GB/s
*** This first iteration will include cold start effects for dynamic import, hardware caches. ***
```

