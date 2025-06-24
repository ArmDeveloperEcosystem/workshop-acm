
# syntax=docker/dockerfile:1

# Build: 1st stage
FROM python:3.10-slim AS builder
EXPOSE 5000

# Install dependencies and update packages to fix vulnerabilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gcc g++ build-essential python3-pip python3-venv git wget google-perftools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Make python virtual environment
RUN python -m venv torch_env

# Clone and patch ao
RUN git clone --recursive https://github.com/pytorch/ao.git && \
    cd ao && \
    git checkout e1cb44ab84eee0a3573bb161d65c18661dc4a307 && \
    curl -L https://github.com/pytorch/ao/commit/738d7f2c5a48367822f2bf9d538160d19f02341e.patch | git apply

# Install torch ao
RUN . torch_env/bin/activate && \
    pip install torch && \
    cd ao && \
    python setup.py install

# Clone and patch torchchat
RUN git clone --recursive https://github.com/pytorch/torchchat.git && \
    cd torchchat && \
    git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6 && \
    wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-modified-generate.py-for-cli-and-browser.patch && \
    wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch && \
    git apply 0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch && \
    git apply --whitespace=nowarn 0001-modified-generate.py-for-cli-and-browser.patch && \
    sed -i 's/"groupsize": 0/"groupsize": 32/' config/data/aarch64_cpu_channelwise.json 

# Install torchchat 
RUN . torch_env/bin/activate && \
    pip install -r torchchat/requirements.txt

# Patch server.py to run on kubernetes
RUN find . -name server.py -exec sed -i -e "s/app\.run()/app.run(host='0.0.0.0')/" {} +

# Prepare hugging face cli 
RUN . torch_env/bin/activate && \
    pip install -U "huggingface_hub[cli]"

# Run torchchat export
RUN --mount=type=secret,id=hf \
    python -m venv torch_env && \
    . torch_env/bin/activate && \
    # Set up hugging face token
    export HF_TOKEN=$(cat /run/secrets/hf) && \
    # Run torchchat export command
    cd torchchat && \  
    python torchchat.py export mistral --output-dso-path exportedModels/mistral.so --quantize config/data/aarch64_cpu_channelwise.json --device cpu --max-seq-length 1024 && \
    # Cleanup
    unset HF_TOKEN && \
    export HF_TOKEN="" && \
    unset HF_TOKEN && \
    unset HUGGING_FACE_HUB_TOKEN && \
    export HUGGING_FACE_HUB_TOKEN="" && \
    unset HUGGING_FACE_HUB_TOKEN && \
    huggingface-cli logout

CMD ["bash", "-c", ". torch_env/bin/activate && cd torchchat && LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python3 torchchat.py server mistral --dso-path exportedModels/mistral.so"]
 