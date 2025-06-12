
# syntax=docker/dockerfile:1
ARG HF_TOKEN


# Build: 1st stage
FROM python:3.10-slim AS builder
ARG HF_TOKEN
EXPOSE 5000
EXPOSE 8501

# Install dependencies
RUN apt-get update && \
    apt-get install -y gcc g++ build-essential python3-pip python3-venv git wget google-perftools

ENV HF_HOME=/hfcache
ENV TORCHCHAT_MODELDIR=/model

RUN python -m venv torch_env && \
    . torch_env/bin/activate && \
    # Clone and patch pytorch/ao
    git clone --recursive https://github.com/pytorch/ao.git && \
    cd ao && \
    git checkout 174e630af2be8cd18bc47c5e530765a82e97f45b && \
    wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-Feat-Add-support-for-kleidiai-quantization-schemes.patch && \
    git apply --whitespace=nowarn 0001-Feat-Add-support-for-kleidiai-quantization-schemes.patch && \
    cd ../ && \
    # Clone and patch pytorch/torchchat
    git clone --recursive https://github.com/pytorch/torchchat.git && \
    cd torchchat && \
    git checkout 925b7bd73f110dd1fb378ef80d17f0c6a47031a6 && \
    wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-modified-generate.py-for-cli-and-browser.patch && \
    wget https://raw.githubusercontent.com/ArmDeveloperEcosystem/PyTorch-arm-patches/main/0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch && \
    git apply 0001-Feat-Enable-int4-quantized-models-to-work-with-pytor.patch && \
    git apply --whitespace=nowarn 0001-modified-generate.py-for-cli-and-browser.patch && \
    pip install -r requirements.txt && \
    wget https://github.com/ArmDeveloperEcosystem/PyTorch-arm-patches/raw/main/torch-2.5.0.dev20240828+cpu-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl && \
    pip install --force-reinstall torch-2.5.0.dev20240828+cpu-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl && \
    cd .. && \
    pip uninstall torchao && cd ao/ && rm -rf build && python setup.py install && \
    # Prepare hugging face cli 
    pip install -U "huggingface_hub[cli]" && \
    git config --global credential.helper store && \
    huggingface-cli login --token $HF_TOKEN --add-to-git-credential && \
    cd ../torchchat && \
    python torchchat.py export mistral --output-dso-path exportedModels/mistral.so --quantize config/data/aarch64_cpu_channelwise.json --device cpu --max-seq-length 1024 && \
    # Cleanup
    huggingface-cli logout

CMD ["bash", "-c", ". torch_env/bin/activate && cd torchchat && LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libtcmalloc.so.4 TORCHINDUCTOR_CPP_WRAPPER=1 TORCHINDUCTOR_FREEZING=1 OMP_NUM_THREADS=16 python3 torchchat.py server mistral --dso-path exportedModels/mistral.so"]
