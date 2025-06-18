# LLM Server

This dockerfile defines the backend server for this workshop.

## Dockerfile Overview

The file takes `HF_TOKEN` as Hugging Face token input variable, allowing secure access to models during the build.

It then installs all dependencies and configuration needed to run the server. It installs PyTorch using a specific version that is optimized for `arm64` based hardware.

## Usage

### Build the Docker Image

```sh
docker buildx build --platform linux/arm64 -t workshopllm . --build-arg HF_TOKEN=< insert token here >
```

### Run the Container

```sh
docker run -d -p 5000:5000 workshopllm
```
