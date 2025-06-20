# LLM Client

This dockerfile defines the backend server for this workshop.

## Dockerfile Overview

The file file has two stages.

The first gets the specific version that matches the version used for the server, and then modifies the browser to take the URL as an environment variable.

The second stage then copies just the files it needs and installs the required dependencies.

## Usage

### Build the Docker Image

```sh
docker buildx build --platform linux/arm64,linux/amd64 -t workshopclient .
```

### Run the Container

```sh
export TORCHCHAT_BASE_URL=<ip address of server>
docker run -d -p 8501:8501 -e TORCHCHAT_BASE_URL workshopclient
```
