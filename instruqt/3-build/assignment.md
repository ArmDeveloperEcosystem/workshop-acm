sudo apt-get update
sudo apt-get install docker.io -y
sudo docker build -t acmworkshopllm . --build-arg HF_TOKEN=h